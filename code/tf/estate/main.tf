# Creates the folder hierarchy and the projects of an estate. This is the
# skeleton every layout in Appendix A is a different arrangement of: the
# appendix's seven designs differ in folder structure and scale, not in the
# resources they need, so they are seven inputs to this module rather than seven
# modules.
#
# Terraform cannot reference other instances of the same resource block, so the
# hierarchy is built in waves by depth. Four levels covers the deepest layout in
# Appendix A -- organization, business units, one business unit, environment --
# and 2.8 caps nesting at ten.

locals {
  depth1 = { for k, f in var.folders : k => f if f.parent == null }
  depth2 = { for k, f in var.folders : k => f if f.parent != null && contains(keys(local.depth1), f.parent) }
  depth3 = { for k, f in var.folders : k => f if f.parent != null && contains(keys(local.depth2), f.parent) }
  depth4 = { for k, f in var.folders : k => f if f.parent != null && contains(keys(local.depth3), f.parent) }

  # Every folder's resource name, whatever depth it was created at, so projects
  # can be attached without caring about the shape of the tree.
  folder_names = merge(
    { for k, v in google_folder.depth1 : k => v.name },
    { for k, v in google_folder.depth2 : k => v.name },
    { for k, v in google_folder.depth3 : k => v.name },
    { for k, v in google_folder.depth4 : k => v.name },
  )
}

# A folder declared at a depth this module does not build would be created
# silently in the wrong place, or not at all. Fail instead.
resource "terraform_data" "depth_check" {
  lifecycle {
    precondition {
      condition     = length(var.folders) == length(local.depth1) + length(local.depth2) + length(local.depth3) + length(local.depth4)
      error_message = "A folder is nested deeper than four levels, or names a parent that does not exist."
    }
  }
}

resource "google_folder" "depth1" {
  for_each = local.depth1

  display_name        = each.value.display_name
  parent              = "organizations/${var.org_id}"
  deletion_protection = true
}

resource "google_folder" "depth2" {
  for_each = local.depth2

  display_name        = each.value.display_name
  parent              = google_folder.depth1[each.value.parent].name
  deletion_protection = true
}

resource "google_folder" "depth3" {
  for_each = local.depth3

  display_name        = each.value.display_name
  parent              = google_folder.depth2[each.value.parent].name
  deletion_protection = true
}

resource "google_folder" "depth4" {
  for_each = local.depth4

  display_name        = each.value.display_name
  parent              = google_folder.depth3[each.value.parent].name
  deletion_protection = true
}

resource "google_project" "this" {
  for_each = var.projects

  name       = each.key
  project_id = each.key
  folder_id  = local.folder_names[each.value.folder]

  billing_account = var.billing_account
  labels          = each.value.labels

  deletion_policy = var.deletion_policy

  # An unset auto_create_network leaves the default network in place, which is
  # the thing constraints/compute.skipDefaultNetworkCreation exists to stop
  # (31.6). Set it here too, so an estate is correct even before the
  # organization policy is applied.
  auto_create_network = false
}
