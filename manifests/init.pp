# == Class: nodejs: See README.md for documentation.
class nodejs(
  $cmd_exe_path                = $nodejs::params::cmd_exe_path,
  $legacy_debian_symlinks      = $nodejs::params::legacy_debian_symlinks,
  $manage_package_repo         = $nodejs::params::manage_package_repo,
  $nodejs_debug_package_ensure = $nodejs::params::nodejs_debug_package_ensure,
  $nodejs_debug_package_name   = $nodejs::params::nodejs_debug_package_name,
  $nodejs_dev_package_ensure   = $nodejs::params::nodejs_dev_package_ensure,
  $nodejs_dev_package_name     = $nodejs::params::nodejs_dev_package_name,
  $nodejs_package_ensure       = $nodejs::params::nodejs_package_ensure,
  $nodejs_package_name         = $nodejs::params::nodejs_package_name,
  $npm_package_ensure          = $nodejs::params::npm_package_ensure,
  $npm_package_name            = $nodejs::params::npm_package_name,
  $npm_path                    = $nodejs::params::npm_path,
  $npmrc_auth                  = $nodejs::params::npmrc_auth,
  $npmrc_config                = $nodejs::params::npmrc_config,
  $npmrc_user                  = $nodejs::params::npmrc_user,
  $npmrc_group                 = $nodejs::params::npmrc_group,
  $repo_class                  = $nodejs::params::repo_class,
  $repo_enable_src             = $nodejs::params::repo_enable_src,
  $repo_ensure                 = $nodejs::params::repo_ensure,
  $repo_pin                    = $nodejs::params::repo_pin,
  $repo_priority               = $nodejs::params::repo_priority,
  $repo_proxy                  = $nodejs::params::repo_proxy,
  $repo_proxy_password         = $nodejs::params::repo_proxy_password,
  $repo_proxy_username         = $nodejs::params::repo_proxy_username,
  $repo_url_suffix             = $nodejs::params::repo_url_suffix,
  $use_flags                   = $nodejs::params::use_flags,
) inherits nodejs::params {

  validate_bool($legacy_debian_symlinks)
  validate_bool($manage_package_repo)

  if $manage_package_repo and !$repo_class {
    fail("${module_name}: The manage_package_repo parameter was set to true but no repo_class was provided.")
  }

  if $nodejs_debug_package_name {
    validate_string($nodejs_debug_package_name)
  }

  if $nodejs_dev_package_name {
    validate_string($nodejs_dev_package_name)
  }

  if $npm_package_name and $npm_package_name != false {
    validate_string($npm_package_name)
  }

  if $npmrc_auth {
    if is_string($npmrc_auth) == false {
      fail('npmrc_auth must be a string')
    }
  }

  if $npmrc_user {
    if (is_string($npmrc_user) == false) and (is_integer($npmrc_user) == false) {
      fail('npmrc_user must be a string or integer')
    }
  }

  if $npmrc_group {
    if (is_string($npmrc_group) == false) and (is_integer($npmrc_group) == false) {
      fail('npmrc_group must be a string or integer')
    }
  }

  if $npmrc_config {
    if is_hash($npmrc_config) == false {
      fail('npmrc_config must be a hash')
    }
  }

  validate_array($use_flags)

  include '::nodejs::install'

  if $manage_package_repo {
    include $repo_class
    anchor { '::nodejs::begin': }
    -> Class[$repo_class]
    -> Class['::nodejs::install']
    -> anchor { '::nodejs::end': }
  }
}
