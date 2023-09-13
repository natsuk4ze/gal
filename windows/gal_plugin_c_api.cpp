#include "include/gal/gal_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "gal_plugin.h"

void GalPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  gal::GalPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
