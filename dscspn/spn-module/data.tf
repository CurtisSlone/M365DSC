# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azuread_client_config" "current" {}

data "azuread_application_published_app_ids" "well_known" {}