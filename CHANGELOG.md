# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0] - 2019-03-26
### Fixed 
- Add cluster owned tag on the default worker security group so the ELB controller is able to find it when multiple security groups are applied to nodes

### Added
- Add support for EKS Public/Private endpoint configuration

## [0.3.0] - 2019-03-15
### Added
- suspended_processes on worker groups
- enabled_metrics on worker groups

## [0.2.0] - 2019-03-01
- Added Velero Support
- Resolved issue with using aws_subnet_ids datasource for private_subnets

## [0.1.0] - 2019-02-09
### Added
- Everything
