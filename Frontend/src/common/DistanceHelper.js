
function offsetCoord (cellID, mapWidth) {
  return {
    x: (cellID - 1) % mapWidth,
    y: Math.floor((cellID - 1) / mapWidth)
  }
}

function cubeCoord ({ x, y }) {
  let oddFactor = x & 1
  let z = y - (x - oddFactor) / 2
  return {
    x: x,
    y: -x - z,
    z: z
  }
}

export const calcDistance = (fromCell, toCell, mapWidth) => {
  let fromCube = cubeCoord(offsetCoord(fromCell, mapWidth))
  let toCube = cubeCoord(offsetCoord(toCell, mapWidth))
  let dx = Math.abs(fromCube.x - toCube.x)
  let dy = Math.abs(fromCube.y - toCube.y)
  let dz = Math.abs(fromCube.z - toCube.z)
  return (dx + dy + dz) / 2
}
