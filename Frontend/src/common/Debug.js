let logger = {
  info () { },
  log () { },
  warn () { },
  error () { }
}

if (process.env.NODE_ENV === 'development') {
  logger = console
}

export default logger
