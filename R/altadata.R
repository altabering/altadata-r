#' Initialize retrieve data process
#'
#' @param product_code data product code
#' @param limit number of rows you want to retrieve
#'
#' @return Nothing just set the initial parameters
#' @export
#'
#' @examples
#' \dontrun{
#'   altadata.get_data("co_10_jhucs_03", limit = 50)
#' }
altadata.get_data <- function(product_code, limit) {
  altadata.check_parameters(product_code, "product_code", parameter_type = "character")

  data_api_url <- paste(
    getOption("aldatata.data_api_base_url"),
    product_code,
    "/?format=json",
    "&api_key=",
    getOption("aldatata.api_key"),
    sep =""
  )
  options(aldatata.data_api_url = data_api_url)
  options(aldatata.condition_text = "")

  if(missing(limit)){
    options(aldatata.data_limit = NULL)
  } else {
    altadata.check_parameters(limit, "limit", parameter_type = "numeric")
    options(aldatata.data_limit = limit)
  }
}

#' Fetch data with configurations given before
#'
#' @return dataframe object
#' @export
#'
#' @examples
#' \dontrun{
#'   aldatata.api_key('YOUR_API_KEY')
#'   altadata.get_data("co_10_jhucs_03", limit = 50)
#'   altadata.load()
#' }
altadata.load <- function() {
  data <- c()
  page <- 1
  total_size <- 0
  response_length <- 1
  data_limit <- getOption("aldatata.data_limit")

  while (response_length > 0) {
    request_url <- altadata.query_builder(page)

    tryCatch({
      df <- altadata.request(request_url)
    }, error = function(e){
      print(e)
    })

    data = rbind(data, df)

    response_length <- length(df)
    total_size <- length(data)

    if(!is.null(data_limit)){
      if(total_size > data_limit){
        break
      }
    }

    page <- page + 1
  }

  if(!is.null(data_limit)){
    data <- utils::head(data, data_limit)
  }

  return(data)
}


#' Get customer subscription info
#'
#' @return dataframe object
#' @export
#'
#' @examples
#' \dontrun{
#'   altadata.list_subscription()
#' }
altadata.list_subscription <- function() {
  subscription_api_url <- getOption("aldatata.subscription_api_url")
  subscription_info <- altadata.request(subscription_api_url)

  return(subscription_info)
}


#' Get data header as a vector
#'
#' @param product_code data product code
#'
#' @return vector object
#' @export
#'
#' @examples
#' \dontrun{
#'   aldatata.api_key('YOUR_API_KEY')
#'   altadata.get_header("co_10_jhucs_03")
#' }
altadata.get_header <- function(product_code) {
  altadata.check_parameters(product_code, "product_code", parameter_type = "character")

  request_url <- paste(
    getOption("aldatata.data_api_base_url"),
    product_code,
    "/?format=json",
    "&api_key=",
    getOption("aldatata.api_key"),
    "&page=1",
    sep =""
  )
  json_response <- altadata.request(request_url)
  header_info <- names(json_response)

  return(header_info)
}


#' Select specific columns in the retrieve data process
#'
#' @param selected_columns list of columns to select
#'
#' @return Nothing just set the select parameters
#' @export
#'
#' @examples
#' \dontrun{
#'   altadata.select(c("reported_date", "province_state", "mortality_rate"))
#' }
altadata.select <- function(selected_columns) {
  altadata.check_parameters(selected_columns, "selected_columns", parameter_type = "vector")
  selected_columns_text <- paste(selected_columns, collapse=",")

  condition_text <- paste(
    getOption("aldatata.condition_text"),
    "&columns=",
    selected_columns_text,
    sep = ""
  )

  options(aldatata.condition_text = condition_text)
}

#' Sort data by given column and method in the retrieve data process
#'
#' @param order_column column to which the order is applied
#' @param order_method sorting method. Posibble values: asc or desc
#'
#' @return Nothing just set the sort parameters
#' @export
#'
#' @examples
#' \dontrun{
#'   altadata.sort("province_state", order_method = "desc")
#' }
altadata.sort <- function(order_column, order_method = "asc") {
  altadata.check_parameters(order_column, "order_column", parameter_type = "character")
  altadata.check_parameters(order_method, "order_method", parameter_type = "character")

  if(!(order_method %in% c("asc", "desc"))){
    stop("order_method parameter must be 'asc' or 'desc'")
  }

  condition_text <- paste(
    getOption("aldatata.condition_text"),
    "&order_by",
    order_column,
    "_",
    toString(order_method),
    sep = ""
  )

  options(aldatata.condition_text = condition_text)
}

#' Equal condition by given column and value in the retrieve data process
#'
#' @param condition_column column to which the condition will be applied
#' @param condition_value value to use with condition
#'
#' @return Nothing just set the equal condition parameters
#' @export
#'
#' @examples
#' \dontrun{
#'   altadata.equal("province_state", "Alabama")
#' }
altadata.equal <- function(condition_column, condition_value) {
  altadata.check_parameters(condition_column, "condition_column", parameter_type = "character")

  condition_text <- paste(
    getOption("aldatata.condition_text"),
    "&",
    condition_column,
    "_eq=",
    toString(condition_value),
    sep = ""
  )

  options(aldatata.condition_text = condition_text)
}

#' Not equal condition by given column and value
#'
#' @param condition_column column to which the condition will be applied
#' @param condition_value value to use with condition
#'
#' @return Nothing just set the not equal condition parameters
#' @export
#'
#' @examples
#' \dontrun{
#'   altadata.not_equal("province_state", "Utah")
#' }
altadata.not_equal <- function(condition_column, condition_value) {
  altadata.check_parameters(condition_column, "condition_column", parameter_type = "character")

  condition_text <- paste(
    getOption("aldatata.condition_text"),
    "&",
    condition_column,
    "_neq=",
    toString(condition_value),
    sep = ""
  )

  options(aldatata.condition_text = condition_text)
}

#' Greater than condition by given column and value
#'
#' @param condition_column column to which the condition will be applied
#' @param condition_value value to use with condition
#'
#' @return Nothing just set the greater than condition parameters
#' @export
#'
#' @examples
#' \dontrun{
#'   altadata.greater_than("mortality_rate", 2)
#' }
altadata.greater_than <- function(condition_column, condition_value) {
  altadata.check_parameters(condition_column, "condition_column", parameter_type = "character")

  condition_text <- paste(
    getOption("aldatata.condition_text"),
    "&",
    condition_column,
    "_gt=",
    toString(condition_value),
    sep = ""
  )

  options(aldatata.condition_text = condition_text)
}

#' Greater than equal condition by given column and value
#'
#' @param condition_column column to which the condition will be applied
#' @param condition_value value to use with condition
#'
#' @return Nothing just set the greater than equal condition parameters
#' @export
#'
#' @examples
#' \dontrun{
#'   altadata.greater_than_equal("mortality_rate", 3)
#' }
altadata.greater_than_equal <- function(condition_column, condition_value) {
  altadata.check_parameters(condition_column, "condition_column", parameter_type = "character")

  condition_text <- paste(
    getOption("aldatata.condition_text"),
    "&",
    condition_column,
    "_gte=",
    toString(condition_value),
    sep = ""
  )

  options(aldatata.condition_text = condition_text)
}

#' Less than condition by given column and value
#'
#' @param condition_column column to which the condition will be applied
#' @param condition_value value to use with condition
#'
#' @return Nothing just set the less than condition parameters
#' @export
#'
#' @examples
#' \dontrun{
#'   altadata.less_than("mortality_rate", 2)
#' }
altadata.less_than <- function(condition_column, condition_value) {
  altadata.check_parameters(condition_column, "condition_column", parameter_type = "character")

  condition_text <- paste(
    getOption("aldatata.condition_text"),
    "&",
    condition_column,
    "_lt=",
    toString(condition_value),
    sep = ""
  )

  options(aldatata.condition_text = condition_text)
}

#' Less than equal condition by given column and value
#'
#' @param condition_column column to which the condition will be applied
#' @param condition_value value to use with condition
#'
#' @return Nothing just set the less than equal condition parameters
#' @export
#'
#' @examples
#' \dontrun{
#'   altadata.less_than_equal("mortality_rate", 3)
#' }
altadata.less_than_equal <- function(condition_column, condition_value) {
  altadata.check_parameters(condition_column, "condition_column", parameter_type = "character")

  condition_text <- paste(
    getOption("aldatata.condition_text"),
    "&",
    condition_column,
    "_lte=",
    toString(condition_value),
    sep = ""
  )

  options(aldatata.condition_text = condition_text)
}

#' In condition by given column and value list
#'
#' @param condition_column column to which the condition will be applied
#' @param condition_value value to use with condition
#'
#' @return Nothing just set the in condition parameters
#' @export
#'
#' @examples
#' \dontrun{
#'   altadata.condition_in("province_state", c("Utah", "Alabama"))
#' }
altadata.condition_in <- function(condition_column, condition_value) {
  altadata.check_parameters(condition_column, "condition_column", parameter_type = "character")
  altadata.check_parameters(condition_value, "condition_value", parameter_type = "vector")

  condition_value_text <- paste(condition_value, collapse=",")

  condition_text <- paste(
    getOption("aldatata.condition_text"),
    "&",
    condition_column,
    "_in=",
    condition_value_text,
    sep = ""
  )

  options(aldatata.condition_text = condition_text)
}

#' Not in condition by given column and value list
#'
#' @param condition_column column to which the condition will be applied
#' @param condition_value value to use with condition
#'
#' @return Nothing just set the not in condition parameters
#' @export
#'
#' @examples
#' \dontrun{
#'   altadata.condition_not_in("province_state", c("Utah", "Alabama"))
#' }
altadata.condition_not_in <- function(condition_column, condition_value) {
  altadata.check_parameters(condition_column, "condition_column", parameter_type = "character")
  altadata.check_parameters(condition_value, "condition_value", parameter_type = "vector")

  condition_value_text <- paste(condition_value, collapse=",")

  condition_text <- paste(
    getOption("aldatata.condition_text"),
    "&",
    condition_column,
    "_notin=",
    condition_value_text,
    sep = ""
  )

  options(aldatata.condition_text = condition_text)
}

## Helper functions

# Check parameter types by given inputs
altadata.check_parameters <- function(paramater, paramater_name, parameter_type) {
  if (parameter_type == "vector") {
    if (class(paramater) != "character") {
      stop(paste(paramater_name, " parameter must be ", parameter_type, sep=""))
    }
    else if (length(paramater) < 1) {
      stop(paste(paramater_name, " parameter must contain at least one value", sep=""))
    }
  }
  else if (parameter_type == "character") {
    if (class(paramater) != "character") {
      stop(paste(paramater_name, " parameter must be ", parameter_type, sep=""))
    }
  } else if (parameter_type == "numeric") {
    if (class(paramater) != "numeric") {
      stop(paste(paramater_name, " parameter must be ", parameter_type, sep=""))
    }
  }
}


# Request API and parse the result
altadata.request <- function(request_url) {
  response <- httr::GET(request_url)

  if(httr::status_code(response) != 200){
    stop(httr::content(response, as = "text"), call. = FALSE)
  }

  json_response <- jsonlite::fromJSON(rawToChar(response$content))

  return(json_response)
}


# Create API request url
altadata.query_builder <- function(page) {
  condition_text <- getOption("aldatata.condition_text")

  if(condition_text == ""){
    request_url <- paste(
      getOption("aldatata.data_api_url"),
      "&page=",
      toString(page),
      sep =""
    )
  }
  else {
    request_url <- paste(
      getOption("aldatata.data_api_url"),
      condition_text,
      "&page=",
      toString(page),
      sep =""
    )
  }

  return(request_url)
}
