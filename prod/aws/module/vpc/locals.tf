locals {
  use_az = [
    "${data.aws_region.current.name}a",
     "${data.aws_region.current.name}b", 
     "${data.aws_region.current.name}c",
     "${data.aws_region.current.name}d"
  ]
}
