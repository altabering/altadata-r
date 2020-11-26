library(testthat)
library(altadata)


test_that("list_subscription function test", {
  API_KEY <- Sys.getenv("TEST_API_KEY")
  aldatata.api_key(API_KEY)

  subscription_info <- altadata.list_subscription()
  product_codes <- subscription_info$offer$code
  expected_result <- c("CO_10_JHUCS_04", "CO_08_UNXXX_04", "CO_10_JHUCS_03", "CO_07_IDEAX_02")
 
  expect_equal(product_codes, expected_result)
})

test_that("get_header function test", {
  API_KEY <- Sys.getenv("TEST_API_KEY")
  aldatata.api_key(API_KEY)

  header_info <- altadata.get_header(product_code = "co_10_jhucs_03")
  expected_result <- c("reported_date","province_state","population",
                          "lat","lng","confirmed","prev_confirmed_1d",
                          "new_confirmed","peak_confirmed_1d_flag","active",
                          "deaths","prev_deaths_1d","new_deaths",
                          "most_deaths_1d_flag","recovered","hospitalization_rate",
                          "incidence_rate","mortality_rate","people_hospitalized",
                          "people_tested","testing_rate")
 
  expect_equal(header_info, expected_result)
})

test_that("sort function test", {
  API_KEY <- Sys.getenv("TEST_API_KEY")
  aldatata.api_key(API_KEY)

  altadata.get_data(product_code = "co_10_jhucs_03")
  altadata.sort(order_column = "reported_date", order_method = "asc")
  data <- altadata.load()
  expected_result <- "2020-04-12"
 
  expect_equal(data[1,1], expected_result)
})

test_that("select function test", {
  API_KEY <- Sys.getenv("TEST_API_KEY")
  aldatata.api_key(API_KEY)

  altadata.get_data(product_code = "co_10_jhucs_03")
  altadata.select(selected_columns = c("reported_date", "province_state", "population"))
  data <- altadata.load()
  expected_result <- c("reported_date", "province_state", "population")
 
  expect_equal(names(data), expected_result)
})

test_that("condition_in function test", {
  API_KEY <- Sys.getenv("TEST_API_KEY")
  aldatata.api_key(API_KEY)

  altadata.get_data(product_code = "co_10_jhucs_03")
  altadata.condition_in(condition_column = "province_state", condition_value = c("Utah", "Alabama"))
  data <- altadata.load()
  expected_result <- c("Alabama", "Utah")
 
  expect_equal(unique(data$province_state), expected_result)
})

test_that("condition_not_in function test", {
  API_KEY <- Sys.getenv("TEST_API_KEY")
  aldatata.api_key(API_KEY)
  test_states <- c("Utah", "Alabama", "Georgia")

  altadata.get_data(product_code = "co_10_jhucs_03")
  altadata.condition_not_in(condition_column = "province_state", condition_value = test_states)
  data <- altadata.load()

  expect_true(!all(test_states %in% unique(data$province_state)))
})