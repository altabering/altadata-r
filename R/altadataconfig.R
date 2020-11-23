#' Set ALTADATA API key
#' 
#' @param api_key Optionally passed parameter to set Altadata \code{api_key}.
#' 
#' @return Returns invisibly the currently set \code{api_key}.
#' @export
#' 
#' @examples 
#' \dontrun{
#'   aldatata.api_key('foobar')
#' }
aldatata.api_key <- function(api_key) {
  if (!missing(api_key)) {
    subscription_api_url <- paste(
      "https://www.altadata.io/subscription/api/subscriptions",
      "?api_key=",
      api_key,
      sep =""
    )

    options(aldatata.api_key = api_key)
    options(aldatata.data_api_base_url = "https://www.altadata.io/data/api/")
    options(aldatata.subscription_api_url = subscription_api_url)
    options(aldatata.condition_text = "")
  }
  
  invisible(getOption("aldatata.api_key"))
}


