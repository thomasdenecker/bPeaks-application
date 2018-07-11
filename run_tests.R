library(testthat)
library(shinytest)

test_that("Application works", {
  expect_pass(testApp("/srv/shiny-server/",
                      testnames = "Authentification_Test",
                      compareImages = FALSE))
})

test_that("Application works", {
  expect_pass(testApp("/srv/shiny-server/",
                      testnames = "Homepage_Test",
                      compareImages = FALSE))
})

test_that("Application works", {
  expect_pass(testApp("/srv/shiny-server/",
                      testnames = "Analyzer_Test",
                      compareImages = FALSE))
})

test_that("Application works", {
  expect_pass(testApp("/srv/shiny-server/",
                      testnames = "Explorer_Test",
                      compareImages = FALSE))
})