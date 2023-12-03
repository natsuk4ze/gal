//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <gal/gal_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) gal_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "GalPlugin");
  gal_plugin_register_with_registrar(gal_registrar);
}
