# One backend per environment, with a distinct prefix. This is what makes the
# blast-radius argument in 26.18 true: a mistaken apply in prod cannot reach
# dev's state, because they are different objects behind different IAM.
#
# The bucket lives in the security project and is created by the bootstrap
# layer, not by this configuration -- a root module cannot create the backend
# it is already using (2.21, 26.14).
terraform {
  backend "gcs" {
    bucket = "rc-saas-bootstrap-tfstate-01"
    prefix = "environments/dev"
  }
}
