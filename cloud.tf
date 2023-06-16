terraform {
  cloud {
    organization = "anydream-xyz"

    workspaces {
      name = "anyterra-paid"
    }
  }
}