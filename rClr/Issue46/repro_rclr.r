# Sys.which('mono.exe')

.libPaths(c('f:/Rlib_dev', .libPaths()))
# library(rClrDevtools)
# cpDebugBins()




Sys.setenv(RCLR='Mono')
library(rClr)
library(testthat)
#  clrGetLoadedAssemblies()

testDir <- system.file('tests', package='rClr') 
stopifnot(file.exists(testDir))
source(file.path(testDir, 'load_libs.r'))

context("rClr essentials")

areClrRefEquals <- function(x, y) {clrCallStatic('System.Object', 'ReferenceEquals', x, y)}

expectArrayTypeConv <- function(clrType, arrayLength, expectedRObj) {
  tn <- "Rclr.TestArrayMemoryHandling"
  arrayLength <- as.integer(arrayLength)
  expect_equal( clrCallStatic(tn, paste0("CreateArray_", clrType), arrayLength ), expectedRObj )
}

createArray <- function(clrType, arrayLength, elementObject) {
  tn <- "Rclr.TestArrayMemoryHandling"
  arrayLength <- as.integer(arrayLength)
  if(missing(elementObject)) { return(clrCallStatic(tn, paste0("CreateArray_", clrType), arrayLength )) }
  clrCallStatic(tn, paste0("CreateArray_", clrType), arrayLength, elementObject )
}

expectClrArrayElementType <- function(rObj, expectedClrTypeName) {
  tn <- "Rclr.TestArrayMemoryHandling"
  expect_true( clrCallStatic(tn, 'CheckElementType', rObj , clrGetType(expectedClrTypeName) ))
}

callTestCase <- function(...) {
  clrCallStatic(cTypename, ...)
}

test_that("Booleans are marshalled correctly", {
  expect_that( callTestCase( "GetFalse"), is_false() )
  expect_that( callTestCase( "GetTrue"), is_true() )
  expect_that( callTestCase( "IsTrue", TRUE), is_true() )
  expect_that( callTestCase( "IsTrue", FALSE), is_false() )
})

test_package('rClr')
history()


$(LibraryPath);$(VSInstallDir);$(VSInstallDir)lib;f:/bin/Mono_dev\lib;f:/bin/Mono_dev\bin



library(swiftdev)
cpSwiftBin(srcDir='f:/src/csiro/stash/per202/swift')

library(ophct)
data(swift_sample_data)
modelSim <- createSubarea('SACSMA', 1.0)


history()
sessionInfo()
str(sessionInfo())
names(sessionInfo())
sessionInfo()$otherPkgs
str(sessionInfo()$otherPkgs)
pkgs = (sessionInfo()$otherPkgs)
names(pkgs)
history()



