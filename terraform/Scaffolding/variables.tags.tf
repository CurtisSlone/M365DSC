# Licensed under the MIT License.

variable "add_tags" {
  description = "Map of custom tags."
  type        = map(string)
  default     = {}
}