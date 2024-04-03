variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "hello-world-cluster"
}

variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster"
  type        = list(string)
  default     = [
    "subnet-0baba852a73770e69",
    "subnet-01e9c9e77804758b3",
    "subnet-018439468341a0a24"
  ]
}

variable "cluster_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster"
  type        = string
  default     = "arn:aws:iam::533267319212:role/EKS-Cluster-Role"
}
