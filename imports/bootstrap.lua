retro = retro or {}

retro.resourceName = 'retro-kit'
retro.version = GetResourceMetadata('retro-kit', 'version', 0) or 'unknown'

print(('^2[retro-kit] v%s loaded in resource "%s"^0'):format(
  retro.version,
  GetCurrentResourceName()
))