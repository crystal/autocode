# load deps
autocode = require '../autocode'
fs       = require 'fs'
mkdirp   = require 'mkdirp'
path     = require 'path'
request  = require 'sync-request'
semver   = require 'semver'
untar    = require 'untar.js'
userHome = require 'user-home'
zlib     = require 'zlib'
lodash   = require 'lodash'

install = (opts) ->
  # hardcoded host
  host = 'github.com'
  
  # get module name
  if typeof opts == 'object' && opts.name
    module_name = opts.name
  
  # get module version
  if typeof opts == 'object' && opts.version
    module_version = opts.version
  else if module_name.match '@'
    module_parse = module_name.split '@'
    module_name = module_parse[0]
    module_version = module_parse[1]
  else
    module_version = 'latest'
  
  # require module name
  if !module_name
    throw new Error "Module Name is required for `autocode install`."
  
  console.log "Loading module (#{module_name})...".blue
  
  # set headers for github
  headers = {
    'User-Agent': 'Crystal Autocode <support@crystal.sh> (https://crystal.sh/autocode)'
  }
  
  # get access token url
  access_token_url = ''
  if process.env.GITHUB_ACCESS_TOKEN
    access_token_url += "?access_token=#{process.env.GITHUB_ACCESS_TOKEN}"
  
  if module_version == 'latest'
    # get latest release
    release_url = "https://api.github.com/repos/#{module_name}/releases/latest#{access_token_url}"
    release_resp = request 'get', release_url, { headers: headers }
    if release_resp.statusCode != 200
      throw new Error "Module (#{module_name}) does not exist in the Crystal Hub."
    release = JSON.parse release_resp.body
    if !release
      throw new Error "Unable to locate generator (#{name})."
    tag_name = release.tag_name
    console.log "Latest version is #{release.tag_name}.".green
  else
    # get releases
    release_url = "https://api.github.com/repos/#{module_name}/releases#{access_token_url}"
    release_resp = request 'get', release_url, { headers: headers }
    if release_resp.statusCode != 200
      throw new Error "Can not connect to github for getting releases."

    releases = JSON.parse release_resp.body

    if util.isPlainObject(releases) and releases.message == 'Not Found'
      throw new Error "Module (#{module_name}) does not exist in the Crystal Hub."

    if !util.isArray releases
      throw new Error "Unable to locate generator (#{name})."

    for release in releases
      release_version = semver.clean release.tag_name
      if semver.satisfies release_version, module_version
        module_version = semver.clean release.tag_name
        tag_name = release.tag_name
        break
    if !tag_name
      throw new Error "Unable to find version (#{module_version}) for module (#{module_name})."
    console.log "Found version (#{module_version}) with tag (#{tag_name}).".green
  
  # check if autocode config exists for project
  if opts.force != true
    config_url = "https://api.github.com/repos/#{module_name}/contents/.autocode/config.yml?ref=#{tag_name}"
    config_resp = request 'get', config_url, { headers: headers }
    if config_resp.statusCode != 200
      throw new Error "Module (#{module_name}) has not implemented Autocode. Use -f to install anyways."
  
  # get module source url
  tarball_url = "#{release.tarball_url}#{access_token_url}"
  console.log "Downloading from: #{tarball_url}".bold
  tarball_response = request 'get', tarball_url, { headers: headers }
  if tarball_response.statusCode != 200
    throw new Error "Unable to download module (#{module_name})."
  tarball = zlib.gunzipSync tarball_response.body
  if !tarball
    throw new Error "Unable to unzip module (#{module_name})."
  
  # get module path
  module_path = path.normalize "#{userHome}/.autocode/module/#{host}/#{module_name}/#{module_version}"
  
  # untar module
  untar.untar(tarball).forEach (file) ->
    filename = file.filename.split('/').slice(1).join('/')
    file_path = path.dirname(filename)
    mkdirp.sync "#{module_path}/#{file_path}"
    buffer = new Buffer(file.fileData.length)
    i = 0
    while i < file.fileData.length
      buffer.writeUInt8 file.fileData[i], i
      i++
    fs.writeFileSync "#{module_path}/#{filename}", buffer
    
  project = new autocode module_path
  project.update()
  project.build()
  
  console.log "Successfully installed #{module_name} at: #{module_path}".green
  
module.exports = install
