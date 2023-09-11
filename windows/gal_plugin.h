#ifndef FLUTTER_PLUGIN_GAL_PLUGIN_H_
#define FLUTTER_PLUGIN_GAL_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace gal {

class GalPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  GalPlugin();

  virtual ~GalPlugin();

  // Disallow copy and assign.
  GalPlugin(const GalPlugin&) = delete;
  GalPlugin& operator=(const GalPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace gal

#endif  // FLUTTER_PLUGIN_GAL_PLUGIN_H_
