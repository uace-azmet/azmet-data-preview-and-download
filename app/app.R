

# Preview and download hourly and daily data by specified stations and date ranges from API database


# SETUP -------------------------


# Libraries -----

library(azmetr)
library(dplyr)
library(lubridate)
library(shiny)
library(shinydashboard)
library(vroom)

# Functions -----

#source("./R/fxnABC.R", local = TRUE)

# Scripts -----

#source("./R/scr##DEF.R", local = TRUE)


# SHINY APP: UI  -------------------------


ui <- fluidPage(
  
  # <html> : begin -----
  
  HTML('
    <html lang="en" dir="ltr" prefix="content: http://purl.org/rss/1.0/modules/content/  dc: http://purl.org/dc/terms/  foaf: http://xmlns.com/foaf/0.1/  og: http://ogp.me/ns#  rdfs: http://www.w3.org/2000/01/rdf-schema#  schema: http://schema.org/  sioc: http://rdfs.org/sioc/ns#  sioct: http://rdfs.org/sioc/types#  skos: http://www.w3.org/2004/02/skos/core#  xsd: http://www.w3.org/2001/XMLSchema# " class="sticky-footer js" style="--scrollbar-width:19px;">
  '),
  
  # <head> -----
  
  HTML('
    <head>
      <meta charset="utf-8">
      <meta name="Generator" content="Drupal 9 (https://www.drupal.org)">
      <meta name="MobileOptimized" content="width">
      <meta name="HandheldFriendly" content="true">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta http-equiv="x-ua-compatible" content="ie=edge">
      
      <link rel="shortcut icon" href="https://staging.azmet.arizona.edu/profiles/custom/az_quickstart/themes/custom/az_barrio/favicon.ico" type="image/vnd.microsoft.icon">
      <link rel="canonical" href=""> <!-- https://staging.azmet.arizona.edu/application-areas/chill/station-level-summaries-for-chill -->
      <link rel="shortlink" href=""> <!-- https://staging.azmet.arizona.edu/node/44 -->
      <link rel="revision" href=""> <!-- https://staging.azmet.arizona.edu/application-areas/chill/station-level-summaries-for-chill -->
      
      <!-- script type="text/javascript" async="" src="https://analytics.tiktok.com/i18n/pixel/config.js?sdkid=C4PARG9PGM656MIKL3R0&amp;hostname=staging.azmet.arizona.edu"></script -->
      <!-- script async="true" src="https://tr.snapchat.com/config/edu/5faf3b90-c2fa-4e6e-bc7d-0d3ff6b1ad2c.js" crossorigin="anonymous"></script -->
      <script type="text/javascript" async="" src="https://www.googletagmanager.com/gtag/js?id=G-7PV3540XS3&amp;l=dataLayer&amp;cx=c"></script>
      <!-- script type="text/javascript" async="" src="https://analytics.tiktok.com/i18n/pixel/events.js?sdkid=C4PARG9PGM656MIKL3R0&amp;lib=ttq"></script -->
      <!-- script type="text/javascript" async="" src="https://sc-static.net/scevent.min.js"></script -->
      <script type="text/javascript" async="" src="https://www.google-analytics.com/analytics.js"></script>
      <script src="https://www.googletagmanager.com/gtm.js?id=GTM-ML2BZB" async=""></script>
      <script src="/sites/default/files/google_tag/az_comprehensive/google_tag.script.js?rmhodt" defer=""></script>
      
      <title>Data Preview and Download | azmet.arizona.edu</title>
      
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/profiles/custom/az_quickstart/modules/custom/az_flexible_page/css/az_flexible_page.theme.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/ajax-progress.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/align.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/autocomplete-loading.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/fieldgroup.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/container-inline.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/clearfix.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/details.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/hidden.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/item-list.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/js.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/nowrap.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/position-container.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/progress.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/reset-appearance.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/resize.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/sticky-header.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/system-status-counter.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/system-status-report-counters.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/system-status-report-general-info.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/tabledrag.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/tablesort.module.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/core/modules/system/css/components/tree-child.module.css?rmhodt">
      
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/modules/custom/azmet_views/css/azmet_views.css?rv4g8p">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/modules/custom/azmet_views/fonts/icomoon/style.css?rv4g8p">
      
      <link rel="stylesheet" media="all" href="style.css">
      
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/modules/contrib/extlink/extlink.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/modules/contrib/paragraphs/css/paragraphs.unpublished.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/profiles/custom/az_quickstart/modules/custom/az_paragraphs/css/az_paragraphs_full_width.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/profiles/custom/az_quickstart/modules/custom/az_paragraphs/css/az_paragraphs_az_text_background.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/user.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/progress.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/profiles/custom/az_quickstart/themes/custom/az_barrio/css/az-media-display.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/affix.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/alerts.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/book.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/comments.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/contextual.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/feed-icon.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/field.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/header.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/help.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/icons.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/image-button.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/item-list.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/list-group.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/node-preview.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/page.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/search-form.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/shortcut.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/skip-link.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/tabledrag.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/tableselect.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/tablesort-indicator.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/ui.widget.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/tabs.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/vertical-tabs.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/views.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/components/ui-dialog.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/profiles/custom/az_quickstart/themes/custom/az_barrio/css/style.css?rmhodt">
      <link rel="stylesheet" media="print" href="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/css/print.css?rmhodt">
      <link rel="stylesheet" media="all" href="https://use.typekit.net/emv3zbo.css">
      <link rel="stylesheet" media="all" href="https://fonts.googleapis.com/css?family=Material+Icons+Sharp">
      <link rel="stylesheet" media="all" href="https://cdn.digital.arizona.edu/lib/az-icons/main/az-icons-styles.css">
      <link rel="stylesheet" media="all" href="https://cdn.digital.arizona.edu/lib/arizona-bootstrap/2.0.13/css/arizona-bootstrap.min.css">
      <link rel="stylesheet" media="all" href="https://staging.azmet.arizona.edu/profiles/custom/az_quickstart/themes/custom/az_barrio/css/az-barrio-off-canvas-nav.css?rmhodt">
      
      <!-- script charset="utf-8" src="https://analytics.tiktok.com/i18n/pixel/identify.js"></script -->
      
      <!-- for all apps -->
      <style>body {font-size: 125% !important;}</style>
      <style>#page-wrapper {margin-left: -15px; margin-right: -15px; !important;}</style>
      <style>@font-face {font-family: "icomoon"; src: url("icomoon.eot") format("embedded-opentype"), url("icomoon.ttf") format("truetype"), url("icomoon.woff") format("woff"); !important;}</style>
      
      <!-- specific to this app -->
      
      <style>#downloadTSV {background-color: transparent !important; border-color: #001C48 !important; color: #001C48 !important; font-size: 100% !important; padding-top: 6px !important; padding-bottom: 6px !important;}</style>
      <style>#downloadTSV:hover {background-color: #001C48 !important; border: 0 px !important; color: #FFFFFF !important; outline: none !important;}</style>
      <style>#downloadTSV:focus {background-color: #001C48 !important; border: 0 px !important; color: #FFFFFF !important; outline: 6px !important;}</style>
      <style>#previewData {background-color: transparent !important; border-color: #001C48 !important; color: #001C48 !important; font-size: 100% !important; padding-top: 6px !important; padding-bottom: 6px !important;}</style>
      <style>#previewData:hover {background-color: #001C48 !important; border: 0 px !important; color: #FFFFFF !important; outline: none !important;}</style>
      <style>#previewData:focus {background-color: #001C48 !important; border: 0 px !important; color: #FFFFFF !important; outline: 6px !important;}</style>
      <style>#sidebarPanel {background-color: #E2E9EB !important; border-radius: 0px !important; padding-bottom: 24px !important; padding-top: 12px !important; margin-bottom: 72px !important;}</style>
      <style>.datepicker {background-color: #FFFFFF !important; color: #000000 !important; font-size: 100% !important;}</style>
      <style>.form-control {font-size: 100% !important;}</style>
      <style>.shiny-html-output {max-height: 381px; min-height: auto; overflow: auto;}</style>
      <style>.shiny-html-output thead th {position: sticky; top: 0;}</style>
      <style>.shiny-output-error-datepicker {background-color: #403635; border: 1px solid rgba(0,0,0,.125); border-radius: 0px; box-shadow: inset 0 1px 1px rgb(0 0 0 / 5%); color: #FFFFFF; font-size: 125%; font-style: regular; font-weight: bold; margin-bottom: 20px; padding: 12px;}</style>
      <style>.shiny-output-error-datepickerBlank {background-color: #FFFFFF; border: 1px solid rgba(0,0,0,0); border-radius: 0px; box-shadow: inset 0 1px 1px rgb(0 0 0 0); color: #FFFFFF; font-size: 125%; font-style: regular; font-weight: bold; margin-bottom: 20px; padding: 12px;}</style>
      <style>.shiny-notification {background-color: #403635; border: 1px solid rgba(0,0,0,.125); border-radius: 0px; box-shadow: inset 0 1px 1px rgb(0 0 0 / 5%); color: #FFFFFF; font-size: 125%; font-style: italic; font-weight: medium; margin-bottom: 20px; padding: 12px; position: fixed; top: calc(50%); left: calc(40%)}</style>
      
    </head>
  '),
  
  # <body> -----
  
  HTML('
      <body class="exclude-node-title layout-no-sidebars page-node-44 path-node node--type-az-flexible-page">
        <a href="#content" class="visually-hidden focusable skip-link">Skip to main content</a>
        <noscript aria-hidden="true"><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-ML2BZB" height="0" width="0" style="display:none;visibility:hidden"></iframe>
        </noscript>
          
          <div class="dialog-off-canvas-main-canvas" data-off-canvas-main-canvas="">
            
            <div id="page-wrapper">
              
              <div id="page">
  '),
  
  # <body> "header" -----
  
  HTML('
                <header id="header" class="header" role="banner" aria-label="Site header">
                  
                  <header class="bg-red arizona-header" id="header_arizona" role="banner">
                    
                    <div class="container">
                      
                      <div class="row">
                        <a class="arizona-logo" href="https://www.arizona.edu" title="The University of Arizona homepage" target="_blank" rel="noopener nofollow noreferrer">
                          <img class="arizona-line-logo" alt="The University of Arizona Wordmark Line Logo White" src="https://cdn.digital.arizona.edu/logos/v1.0.0/ua_wordmark_line_logo_white_rgb.min.svg">
                        </a>
                        <section class="ml-auto d-none d-lg-block d-xl-block region region-header-ua-utilities">
                          <div class="search-block-form block block-search block-search-form-block" data-drupal-selector="search-block-form" id="block-az-barrio-search" role="search">
                            <div class="content">
                              <!-- form action="/search/node" method="get" id="search-block-form" accept-charset="UTF-8" class="search-form search-block-form" -->
                                <!-- div class="input-group" -->
                                  <!-- label for="edit-keys" class="sr-only">Search</label -->
                                    <!-- input title="Enter the terms you wish to search for." data-drupal-selector="edit-keys" type="search" id="edit-keys" name="keys" value="" size="15" maxlength="128" class="form-search form-control" placeholder="Search this site" aria-label="Search this site" -->
                                      <!-- div data-drupal-selector="edit-actions" class="form-actions js-form-wrapper input-group-append" id="edit-actions" -->
                                        <!-- button data-drupal-selector="edit-submit" type="submit" id="edit-submit" value="Search" class="button js-form-submit form-submit btn" -->
                                          <!-- span class="material-icons-sharp">search</span -->
                                        <!-- /button -->
                                      <!-- /div -->
                                <!-- /div -->
                              <!-- /form -->
                            </div>
                          </div>
                        </section>
                      </div> <!-- /.row -->
                    
                    </div> <!-- /.container -->
                    
                    <!-- div class="redbar-buttons d-lg-none" -->
                      <!-- button data-toggle="offcanvas" type="button" data-target="#navbarOffcanvasDemo" aria-controls="navbarOffcanvasDemo" class="btn btn-redbar" id="jsAzSearch" -->
                        <!-- span class="icon material-icons-sharp"> search </span -->
                        <!-- span class="icon-text"> search </span -->
                      <!-- /button -->
                      <!-- button data-toggle="offcanvas" type="button" data-target="#navbarOffcanvasDemo" aria-controls="navbarOffcanvasDemo" class="btn btn-redbar" -->
                        <!-- span class="icon material-icons-sharp"> menu </span -->
                        <!-- span class="icon-text"> menu </span -->
                      <!-- /button -->
                    <!-- /div -->
                  
                  </header>
                  
                  <div class="header page-row" id="header_site" role="banner">
                    
                    <div class="container">
                      
                      <div class="row">
                        <div class="col-12 col-sm-6 col-lg-4">
                          <section class="region region-branding">
                            <div id="block-az-barrio-branding" class="clearfix block block-system block-system-branding-block">
                              <a href="https://azmet.arizona.edu" title="Arizona Meteorological Network | Home" class="qs-site-logo d-block" target="_blank" rel="home">
                                <img class="img-fluid" src="azmet-logo.png" alt="Arizona Meteorological Network | Home" typeof="foaf:Image">
                              </a>
                            </div>
                          </section>
                        </div>
                        <div class="col-12 col-sm-6 col-lg-8">
                          <div class="row">
                          </div>
                        </div>
                      </div> <!-- /.row -->
                    
                    </div> <!-- /.container -->
                    
                    <div class="container">
                      
                      <div class="row">
                        <div class="col-lg">
                          <!-- nav class="navbar-offcanvas has-navigation-region has-off-canvas-region" id="navbarOffcanvasDemo" -->
                            <!-- div class="navbar-offcanvas-header" -->
                              <!-- div class="bg-chili d-flex justify-content-between align-items-center" -->
                                <!-- a href="/" class="btn btn-redbar" -->
                                  <!-- span class="icon material-icons-sharp"> home </span -->
                                  <!-- span class="icon-text"> home </span -->
                                <!-- /a -->
                                <!-- button data-toggle="offcanvas" type="button" data-target="#navbarOffcanvasDemo" aria-controls="navbarOffcanvasDemo" class="btn btn-redbar" -->
                                  <!-- span class="icon material-icons-sharp"> close </span -->
                                  <!-- span class="icon-text"> close </span -->
                                <!-- /button -->
                              <!-- /div -->
                              
                              <!-- section class="region region-navigation-offcanvas" -->
                                <!-- div class="search-block-form bg-white navbar-offcanvas-search" data-drupal-selector="search-block-form-2" id="block-az-barrio-offcanvas-searchform" role="search" -->
                                  <!-- form action="/search/node" method="get" id="search-block-form--2" accept-charset="UTF-8" class="search-form search-block-form" -->
                                    <!-- div class="input-group" --
                                      <!-- label for="edit-keys--2" class="sr-only">Search</label -->
                                      <!-- input title="Enter the terms you wish to search for." data-drupal-selector="edit-keys" type="search" id="edit-keys--2" name="keys" value="" size="15" maxlength="128" class="form-search form-control" placeholder="Search this site" aria-label="Search this site" -->
                                        <!-- div data-drupal-selector="edit-actions" class="form-actions js-form-wrapper input-group-append" id="edit-actions--2" -->
                                          <!-- button data-drupal-selector="edit-submit" type="submit" id="edit-submit--2" value="Search" class="button js-form-submit form-submit btn" -->
                                            <!-- span class="material-icons-sharp">search</span -->
                                          <!-- /button -->
                                        <!-- /div -->
                                    <!-- /div -->
                                  <!-- /form -->
                                <!-- /div -->
                              <!-- /section -->
                            
                            <!-- /div -->
                            
                            <!-- section class="region region-navigation" -->
                              <!-- nav role="navigation" aria-labelledby="block-az-barrio-main-menu-menu" id="block-az-barrio-main-menu" class="block block-menu navigation menu--main" -->
                                <!-- h2 class="sr-only" id="block-az-barrio-main-menu-menu">Main navigation</h2 -->
                                <!-- ul block="block-az-barrio-main-menu" class="clearfix navbar-nav flex-lg-row" -->
                                  <!-- li class="nav-item menu-item--collapsed" -->
                                    <!-- a href="/current-conditions" class="nav-link" data-drupal-link-system-path="node/1">Current Conditions</a -->
                                  <!-- /li -->
                                  <!-- li class="nav-item menu-item--collapsed" -->
                                    <!-- a href="/past-data" class="nav-link" data-drupal-link-system-path="node/6">Past Data</a -->
                                  <!-- /li -->
                                  <!-- li class="nav-item menu-item--collapsed active" -->
                                    <!-- a href="/application-areas" class="nav-link active" data-drupal-link-system-path="node/7">Application Areas</a -->
                                  <!-- /li -->
                                  <!-- li class="nav-item menu-item--collapsed" -->
                                    <!-- a href="/about" class="nav-link" data-drupal-link-system-path="node/8">About</a -->
                                  <!-- /li -->
                                <!-- /ul -->
                              <!-- /nav -->
                            <!-- /section -->
                          
                          <!-- /nav -->
                        </div>
                      </div> <!-- /.row -->
                      
                      <!-- div class="row" -->
                        <!-- section class="col-md region region-help" -->
                          <!-- div data-drupal-messages-fallback="" class="hidden" -->
                          <!-- /div -->
                        <!-- /section -->
                      <!-- /div --> <!-- /.row -->
                    
                    </div> <!-- /.container -->
                  </div>
                
                </header>
  '),
  
  # <body> "main-wrapper" : begin -----
  
  HTML('
                <div id="main-wrapper" class="layout-main-wrapper clearfix">
                  
                  <div id="main" role="main">
                    
                    <div class="container">
                      
                      <div class="row">
                        <section class="col-md region region-breadcrumb">
                          <div id="block-az-barrio-breadcrumbs" class="block block-system block-system-breadcrumb-block">
                            <div class="content">
                              <nav role="navigation" aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                  <!-- li class="breadcrumb-item" -->
                                    <!-- a href="/application-areas"><span>« Back to </span>Application Areas</a -->
                                  <!-- /li -->
                                  <!-- li class="breadcrumb-item" -->
                                    <!-- a href="/application-areas/chill">Chill</a -->
                                  <!-- /li -->
                                </ol>
                              </nav>
                            </div>
                          </div>
                        </section>
                      </div> <!-- /.row -->
                      
                      <div class="row">
                      </div>
                    
                    </div> <!-- /.container -->
                    
                    <div class="container">
              
                      <div class="row row-offcanvas row-offcanvas-left clearfix">
                        <main class="main-content col" id="content" role="main">
                          
                          <section class="region region-content">
                            
                            <div id="block-az-barrio-page-title" class="block block-core block-page-title-block">
                              <div class="content">
                                <h1 class="hidden title"><span class="field field--name-title field--type-string field--label-hidden">Data Preview and Download</span></h1>
                              </div>
                            </div>
                            
                            <div id="block-az-barrio-content" class="block block-system block-system-main-block">
                              <div class="content">
                                <article role="article" about="/application-areas" class="node node--type-az-flexible-page node--view-mode-full clearfix">
                                  <div class="node__content clearfix">
                                    <div class="field field--name-field-az-main-content field--type-entity-reference-revisions field--label-hidden field__items">
                                      <div class="field__item">
                                        <div class="mb-5 paragraph background-wrapper paragraph--type--az-text-background paragraph--view-mode--default bg-triangles-top-left bg-azurite py-5 full-width-background">
                          
                                          <div class="container">
                                            <div class="az-full-width-row">
                                              <div class="az-full-width-column-content">
                                                <div class="content">
                                                  <div class="clearfix text-formatted field field--name-field-az-text-area field--type-text-long field--label-hidden field__item">
                                                    <div class="d-flex flex-nowrap">
                                                      <div class="icon-circle d-flex justify-content-center align-items-center mr-3">
                                                        <span class="lm-wrench text-midnight"></span><!-- icon list at: https://staging.azmet.arizona.edu/modules/custom/azmet_views/fonts/icomoon/style.css -->
                                                      </div>
                                                      <div class="titles">
                                                        <h1 class="mt-4 d-inline">Data Preview and Download</h1>
                                                        <h4 class="mb-0 mt-2">Preview and download hourly and daily data by station and date range</h4>
                                                      </div>
                                                    </div>
                                                  </div>
                                                </div>
                                              </div>
                                            </div>
                                          </div> <!-- /.container -->
                                        
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                                </article>
                              </div>
                            </div>
                        
                          </section>
                        
                        </main>
                      </div> <!-- /.row -->
                                           
                    </div> <!-- /.container -->
                  
                  </div> <!-- "main" -->
                  
                  <div class="container">
                
       '),         
  
  # <body> : shiny app -----
  
  sidebarLayout(
    position = "left",
    
    sidebarPanel(
      id = "sidebarPanel",
      width = 4,
      
      verticalLayout(
        helpText(em(
          "Select an AZMet station, specify the time step, and set dates for the period of interest. Then, click or tap 'Preview Data'."
        )),
        
        br(),
        selectInput(
          inputId = "station", 
          label = "AZMet Station",
          choices = stns[order(stns$stationName), ]$stationName,
          selected = "Aguila"
        ),
        
        selectInput(
          inputId = "timeStep", 
          label = "Time Step",
          choices = timeSteps,
          selected = "Hourly"
        ),
        
        dateInput(
          inputId = "startDate",
          label = "Start Date",
          value = Sys.Date() - 1,
          min = apiStartDate,
          max = Sys.Date() - 1,
          format = "MM d, yyyy",
          startview = "month",
          weekstart = 0, # Sunday
          width = "100%",
          autoclose = TRUE
        ),
        
        dateInput(
          inputId = "endDate",
          label = "End Date",
          value = Sys.Date() - 1,
          min = apiStartDate,
          max = Sys.Date() - 1,
          format = "MM d, yyyy",
          startview = "month",
          weekstart = 0, # Sunday
          width = "100%",
          autoclose = TRUE
        ),
        
        br(),
        actionButton(
          inputId = "previewData", 
          label = "Preview Data",
          class = "btn btn-block btn-blue"
        )
      )
    ), # sidebarPanel()
    
    mainPanel(
      id = "mainPanel",
      width = 8,
      
      fluidRow(
        column(width = 11, align = "left", offset = 1, htmlOutput(outputId = "tableTitle"))
      ), 
      
      br(),
      fluidRow(
        column(width = 11, align = "left", offset = 1, tableOutput(outputId = "dataTablePreview"))
      ), 
      
      fluidRow(
        column(width = 11, align = "left", offset = 1, htmlOutput(outputId = "tableFooter"))
      ),
      
      br(),
      fluidRow(
        column(width = 11, align = "left", offset = 1, uiOutput(outputId = "downloadButtonTSV"))
      ),
      
      br(), br(),
      fluidRow(
        column(width = 11, align = "left", offset = 1, htmlOutput(outputId = "tableCaption"))
      ),
      br()
    ) # mainPanel()
  ), # sidebarLayout()
  
  # <body> : "main-wrapper" : end -----
  
  HTML('              
                </div>  <!-- /.container -->
                <div class="container">
                  <br><br>
                </div>  <!-- /.container -->
                
                </div> <!-- "main-wrapper" -->
  '),
  
  # <footer> -----
  
  HTML('
                <footer class="site-footer">
  
                  <div class="bg-warm-gray py-5" role="contentinfo">
                     
                      <section>
                        <div class="container">
                          
                          <div class="row">
                            <div class="col-12 col-sm-5 col-md-4 col-lg-4 text-center-xs text-left-not-xs">
                              <div class="row bottom-buffer-30">
                                <div class="col">
                                  <a href="https://azmet.arizona.edu" title="Arizona Meteorological Network | Home" class="qs-site-logo d-block mt-0" target="_blank" rel="home">
                                    <img class="img-fluid" src="azmet-logo.png" alt="Arizona Meteorological Network | Home" typeof="foaf:Image">
                                  </a>
                                </div>
                              </div>
                            </div>
                            
                            <!-- Force next columns to break to new line at md breakpoint and up -->
                            <div class="w-100 d-block d-sm-none">
                            </div>
                              
                             <section class="col-12 col-sm-7 col-md-8 col-lg-8 region region-footer">
                               <div id="block-footerinfo" class="block block-block-content block-block-content3f132fa8-4eef-48a3-8ff8-cf10a29efd9f">
                                 <div class="content">
                                   <div class="clearfix text-formatted field field--name-body field--type-text-with-summary field--label-hidden field__item">
                                     <div class="text-align-right">
                                       <h5 class="bold mt-0">Arizona Meteorological Network</h5>
                                         <p>1140 E South Campus Dr<br>PO Box 210036<br>Tucson, AZ 85721-0036</p>
                                         <p><!-- a href="https://staging.azmet.arizona.edu/contact" target="_blank">Contact Us</a --><br><a href="mailto:azmet@arizona.edu">Email</a></p>
                                     </div>
                                   </div>
                                 </div>
                               </div>
                             </section>
                              
                            <div class="col-12">
                              <hr>
                            </div>
                              
                          </div> <!-- /.row -->
                            
                        </div> <!-- /.container -->
                      </section>
                        
                      <div id="footer_sub">
                        
                        <div class="container">
                          
                          <div class="row">
                          </div>
                          <div class="row">
                          </div>
                          
                          <div class="row">
                            <div class="col text-center">
                              <p class="font-weight-light"><em>We respectfully acknowledge the University of Arizona is on the land and territories of Indigenous peoples. Today, Arizona is home to 22 federally recognized tribes, with Tucson being home to the O’odham and the Yaqui. Committed to diversity and inclusion, the University strives to build sustainable relationships with sovereign Native Nations and Indigenous communities through education offerings, partnerships, and community service.</em></p>
                              <hr>
                              <p class="small"><a href="https://www.arizona.edu/information-security-privacy" target="_blank" rel="noopener nofollow noreferrer">University Information Security and Privacy</a></p>
                              <p class="small">© 2022 The Arizona Board of Regents on behalf of <a href="https://www.arizona.edu" target="_blank" rel="noopener nofollow noreferrer">The University of Arizona</a>.</p>
                            </div>
                          </div>
                        
                        </div>
                      </div> <!-- "footer-sub" -->
                      
                  </div>
                
                </footer>
  '),
  
  # <html> : end -----
  
  HTML('
              </div> <!-- "page" -->
            
            </div> <!-- "page-wrapper" -->
          
          </div>

        <script src="https://staging.azmet.arizona.edu/core/assets/vendor/jquery/jquery.min.js?v=3.6.0"></script>
        <script src="https://staging.azmet.arizona.edu/core/assets/vendor/jquery-once/jquery.once.min.js?v=2.2.3"></script>
        <script src="https://staging.azmet.arizona.edu/core/misc/drupalSettingsLoader.js?v=9.2.18"></script>
        <script src="https://staging.azmet.arizona.edu/core/misc/drupal.js?v=9.2.18"></script>
        <script src="https://staging.azmet.arizona.edu/core/misc/drupal.init.js?v=9.2.18"></script>
        <script src="https://staging.azmet.arizona.edu/modules/custom/cals_azmet/js/cals_azmet.js?v=1.x"></script>
        <script src="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/js/global.js?v=9.2.18"></script>
        <script src="https://staging.azmet.arizona.edu/themes/contrib/bootstrap_barrio/js/affix.js?v=9.2.18"></script>
        <script src="https://cdn.digital.arizona.edu/lib/arizona-bootstrap/2.0.13/js/arizona-bootstrap.bundle.min.js"></script>
        <script src="https://staging.azmet.arizona.edu/modules/contrib/extlink/extlink.js?v=9.2.18"></script>
        <script src="https://staging.azmet.arizona.edu/profiles/custom/az_quickstart/modules/custom/az_paragraphs/js/az_paragraphs_full_width.js?v=9.2.18"></script>
        <script src="https://staging.azmet.arizona.edu/profiles/custom/az_quickstart/themes/custom/az_barrio/js/az-barrio-off-canvas-nav.js?rmhodt"></script>
        
        <script type="text/javascript" id="">!function(d,g,e){d.TiktokAnalyticsObject=e;var a=d[e]=d[e]||[];a.methods="page track identify instances debug on off once ready alias group enableCookie disableCookie".split(" ");a.setAndDefer=function(b,c){b[c]=function(){b.push([c].concat(Array.prototype.slice.call(arguments,0)))}};for(d=0;d<a.methods.length;d++)a.setAndDefer(a,a.methods[d]);a.instance=function(b){b=a._i[b]||[];for(var c=0;c<a.methods.length;c++)a.setAndDefer(b,a.methods[c]);return b};a.load=function(b,c){var f="https://analytics.tiktok.com/i18n/pixel/events.js";
        a._i=a._i||{};a._i[b]=[];a._i[b]._u=f;a._t=a._t||{};a._t[b]=+new Date;a._o=a._o||{};a._o[b]=c||{};c=document.createElement("script");c.type="text/javascript";c.async=!0;c.src=f+"?sdkid\x3d"+b+"\x26lib\x3d"+e;b=document.getElementsByTagName("script")[0];b.parentNode.insertBefore(c,b)};a.load("C4PARG9PGM656MIKL3R0");a.page()}(window,document,"ttq");</script>
      
      </body>
        	
      <iframe id="__JSBridgeIframe_1.0__" title="jsbridge___JSBridgeIframe_1.0__" style="display: none;"></iframe><iframe id="__JSBridgeIframe_SetResult_1.0__" title="jsbridge___JSBridgeIframe_SetResult_1.0__" style="display: none;"></iframe>
      <iframe id="__JSBridgeIframe__" title="jsbridge___JSBridgeIframe__" style="display: none;"></iframe><iframe id="__JSBridgeIframe_SetResult__" title="jsbridge___JSBridgeIframe_SetResult__" style="display: none;"></iframe>
	
	   </html>     
  ')
  
) # fluidPage()


# SHINY APP: SERVER  --------------------


server <- function(input, output, session) {
  
  # Reactive events -----
  
  # AZMet data ELT
  dfAZMetData <- eventReactive(input$previewData, {
    if (input$startDate > input$endDate) {
      validate(
        "Please select a 'Start Date' that is earlier than or the same as the 'End Date'.",
        errorClass = "datepickerBlank"
      )
    }
    
    idPreview <- showNotification(
      ui = "Preparing data preview . . .", 
      action = NULL, 
      duration = NULL, 
      closeButton = FALSE, 
      type = "message"
    )
    
    on.exit(removeNotification(idPreview), add = TRUE)
    
    fxnAZMetDataELT(
      station = input$station, 
      timeStep = input$timeStep, 
      startDate = input$startDate, 
      endDate = input$endDate
    )
  })
  
  # Format AZMet data for HTML table preview
  dfAZMetDataPreview <- eventReactive(input$previewData, {
    if (input$startDate > input$endDate) {
      validate(
        "Please select a 'Start Date' that is earlier than or the same as the 'End Date'.",
        errorClass = "datepickerBlank"
      )
    }
    
    fxnAZMetDataPreview(
      inData = dfAZMetData(), 
      timeStep = input$timeStep
    )
  })
  
  # Build table caption
  tableCaption <- eventReactive(input$previewData, {
    if (input$startDate > input$endDate) {
      validate(
        "Please select a 'Start Date' that is earlier than or the same as the 'End Date'.",
        errorClass = "datepickerBlank"
      )
    }
    
    tableCaption <- fxnTableCaption(timeStep = input$timeStep)
  })
  
  # Build table title
  tableTitle <- eventReactive(input$previewData, {
    if (input$startDate > input$endDate) {
      validate(
        "Please select a 'Start Date' that is earlier than or the same as the 'End Date'.",
        errorClass = "datepicker"
      )
    }
  
    tableTitle <- fxnTableTitle(
      station = input$station,
      timeStep = input$timeStep,
      startDate = input$startDate,
      endDate = input$endDate
    )
  })
  
  # Outputs -----
  
  output$dataTablePreview <- renderTable(
    expr = dfAZMetDataPreview(), 
    striped = TRUE, 
    hover = TRUE, 
    bordered = FALSE, 
    spacing = "xs", 
    width = "auto", 
    align = "c", 
    rownames = FALSE, 
    colnames = TRUE, 
    digits = NULL, 
    na = "na"
  )
  
  output$downloadButtonTSV <- renderUI({
    req(dfAZMetData())
    downloadButton("downloadTSV", label = "Download .tsv")
  })
  
  output$downloadTSV <- downloadHandler(
    filename = function() {
      paste0(input$station, input$timeStep, input$startDate, "to", input$endDate, ".tsv")
    },
    content = function(file) {
      vroom::vroom_write(x = dfAZMetData(), file = file, delim = "\t")
    }
  )
  
  output$tableFooter <- renderUI({
    req(dfAZMetData())
    helpText(em("Click or tap the button below to download a file of the previewed data with tab-separated values."))
  })
  
  output$tableCaption <- renderUI({
    tableCaption()
  })
  
  output$tableTitle <- renderUI({
    tableTitle()
  })
}


# SHINY APP: RUN  --------------------


shinyApp(ui, server)


# FIN  --------------------

