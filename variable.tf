# variable "wins-key" {
#     default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGKKWxVSu7S00S+I3d8fvhM/Zn0lolC3+xDLnMvhvbAEb361HCy07HCvlUAwTOY5evegm2YIPQCOO+7iG380nPpGL8scp+GHzNctoGU6qpXRcb0Ooh/7/0cbB20d4B1mdiBs8aWPAnFGcilM5iml/IZU8xY7IqncoCJTgPc+o1si6SOnSIQJcRLAxzsdSTvW+C0v4lMKl+1fN6bhb5jNwx4OqWaWdw4gpY3eaC7BbFdWqkYMAoEQY0mGytytYa/EFG6ijcX9zEAe4e9p0k51eY5ZlhILsEHh9hlmEJQHr8BAMhYM8+3DUzHvbiarN+4bfu91d/L+9pGkK7tZkltQTlxFnAxVTYwXTgHKfxOTPaV0r3/QjUxOzNsMIUtVQ8OYWzGjVxhgzKZ0Nzb2q/96R3IHxHjseTvptAOree5xYVqpzbbo7+ObNp8dSyl6fVfRqz8Tj5zoZhQHXANtfDQ05RCX82dVm+/tPQOeUjx0hhMX0V9WtOJyzXeiRZLeydOm0= devopslab@MBP-2"
  
# }

variable "name" {
    description = "name to use"
    type = string
    default = "wins"
  
}

variable "region" {
    description = "region to use"
    type = string
    default = "us-east-1"
  
}

variable "instance-type" {
    description = "instance type to use"
    type = string
    default = "t3.medium"
  
}

variable "instance-name" {
    description = "name to call instance"
    type = map(string)
    default = {
      "name1" = "vps-1"
      "name2" = "vps-2"
      "name3" = "vps-3"
    }
  
}

variable "availability-zone" {
    description = "az to use"
    type = string
    default = "us-east-1a" 
  
}

variable "vpc-cidr" {
    description = "cidr to use"
    type = string
    default = "10.23.0.0/16"
  
}
