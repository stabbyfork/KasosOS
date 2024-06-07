local fs = fs
_G.fs = {
    open=fs.open,
    makeDir=fs.makeDir,
    list=fs.list,
    exists=fs.exists,
    delete=fs.delete,
    isDir=fs.isDir,
    isReadOnly=fs.isReadOnly,
    getFreeSpace=fs.getFreeSpace,
    combine=fs.combine,
    complete=fs.complete
}