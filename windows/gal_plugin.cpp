#include "gal_plugin.h"

#include <flutter/event_channel.h>
#include <flutter/event_sink.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>  // This must be included before many other Windows headers.
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.Storage.Streams.h>
#include <winrt/Windows.Storage.h>
#include <winrt/Windows.System.h>

#include <thread>

namespace gal {

using flutter::EncodableValue;
using std::optional;
using std::string;
using std::vector;
using std::wstring;
using winrt::Windows::Foundation::IAsyncAction;
using winrt::Windows::Foundation::Uri;
using winrt::Windows::Storage::CreationCollisionOption;
using winrt::Windows::Storage::FileAccessMode;
using winrt::Windows::Storage::KnownFolders;
using winrt::Windows::Storage::NameCollisionOption;
using winrt::Windows::Storage::StorageFile;
using winrt::Windows::Storage::StorageFolder;
using winrt::Windows::Storage::Streams::DataWriter;
using winrt::Windows::System::Launcher;

constexpr HRESULT E_UNSUPPORTED_FORMAT = 0x80001000L;

struct Bytes {
  const vector<uint8_t> pattern;
  const int offset;
};

// https://support.microsoft.com/en-au/topic/graphic-file-types-c0374c44-71f8-45dc-a4d5-708064b5c99b
std::unordered_multimap<wstring, Bytes> extension_map = {
    {L"jpg", {{0xFF, 0xD8}, 0}},
    {L"gif", {{0x47, 0x49, 0x46}, 0}},
    {L"bmp", {{0x42, 0x4D}, 0}},
    {L"png", {{0x89, 0x50, 0x4E, 0x47}, 0}},
    {L"tiff", {{0x49, 0x49, 0x2A, 0x00}, 0}},
    {L"tiff", {{0x4D, 0x4D, 0x00, 0x2A}, 0}},
    {L"emf", {{0x20, 0x45, 0x4D, 0x46}, 40}}};

wstring GetExtension(const vector<uint8_t>& data) {
  for (const auto& [ext, bytes] : extension_map) {
    if (data.size() < bytes.pattern.size() + bytes.offset) continue;
    if (std::equal(bytes.pattern.begin(), bytes.pattern.end(),
                   data.begin() + bytes.offset)) {
      return ext;
    }
  }
  throw winrt::hresult_error(E_UNSUPPORTED_FORMAT,
                             L"Image file format must be supported by Windows "
                             L"(.jpg, .png, .gif, .bmp, .tiff, .emf).");
}

void HandleError(
    const winrt::hresult_error e,
    const std::unique_ptr<flutter::MethodResult<EncodableValue>> result) {
  const auto message = winrt::to_string(e.message());
  switch (e.code()) {
    case HRESULT_FROM_WIN32(ERROR_DISK_FULL):
      result->Error("NOT_ENOUGH_SPACE", message);
      break;
    case E_UNSUPPORTED_FORMAT:
      result->Error("NOT_SUPPORTED_FORMAT", message);
      break;
    default:
      result->Error("UNEXPECTED", message);
      break;
  }
}

IAsyncAction Open() { co_await Launcher::LaunchUriAsync(Uri(L"ms-photos:")); }

static IAsyncAction PutMedia(string path, const optional<string> album) {
  std::replace(path.begin(), path.end(), '/', '\\');
  const auto file =
      co_await StorageFile::GetFileFromPathAsync(winrt::to_hstring(path));
  auto folder = KnownFolders::PicturesLibrary();
  if (album) {
    folder = co_await folder.CreateFolderAsync(
        winrt::to_hstring(album.value()),
        CreationCollisionOption::OpenIfExists);
  }
  co_await file.CopyAsync(folder, file.Name(),
                          NameCollisionOption::GenerateUniqueName);
}

static IAsyncAction PutMediaBytes(const vector<uint8_t>& bytes,
                                  const optional<string> album,
                                  const string &name) {
  auto folder = KnownFolders::PicturesLibrary();
  if (album) {
    folder = co_await folder.CreateFolderAsync(
        winrt::to_hstring(album.value()),
        CreationCollisionOption::OpenIfExists);
  }
  auto file = co_await folder.CreateFileAsync(
      winrt::to_hstring(name) + L"." + GetExtension(bytes),
      CreationCollisionOption::GenerateUniqueName);

  auto stream = co_await file.OpenAsync(FileAccessMode::ReadWrite);
  DataWriter dataWriter(stream.GetOutputStreamAt(0));
  dataWriter.WriteBytes(bytes);
  co_await dataWriter.StoreAsync();
  co_await dataWriter.FlushAsync();
  dataWriter.DetachStream();
}

void GalPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto channel = std::make_unique<flutter::MethodChannel<EncodableValue>>(
      registrar->messenger(), "gal",
      &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<GalPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

GalPlugin::GalPlugin() {}

GalPlugin::~GalPlugin() {}

void GalPlugin::HandleMethodCall(
    const flutter::MethodCall<EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<EncodableValue>> result) {
  const auto args = std::get_if<flutter::EncodableMap>(method_call.arguments());
  const auto method = method_call.method_name();

  if (method == "putImage" || method == "putVideo") {
    optional<string> album;
    if (auto p = std::get_if<string>(&args->at(EncodableValue("album")))) {
      album.emplace(*p);
    }
    const auto path = std::get<string>(args->at(EncodableValue("path")));
    std::thread([path, album, result = std::move(result)]() mutable {
      try {
        PutMedia(path, album).get();
        result->Success();
      } catch (const winrt::hresult_error& e) {
        HandleError(e, std::move(result));
      }
    }).detach();
  } else if (method == "putImageBytes") {
    const auto& bytes =
        std::get<vector<uint8_t>>(args->at(EncodableValue("bytes")));
    optional<string> album;
    if (auto p = std::get_if<string>(&args->at(EncodableValue("album")))) {
      album.emplace(*p);
    }
    const auto name = std::get<string>(args->at(EncodableValue("name")));
    std::thread([bytes, album, name, result = std::move(result)]() mutable {
      try {
        PutMediaBytes(bytes, album, name).get();
        result->Success();
      } catch (const winrt::hresult_error& e) {
        HandleError(e, std::move(result));
      }
    }).detach();
  } else if (method == "open") {
    std::thread([] { Open(); }).detach();
    result->Success();
  } else if (method == "hasPermission" || method == "requestPermission") {
    result->Success(true);
  } else {
    result->NotImplemented();
  }
}

}  // namespace gal
