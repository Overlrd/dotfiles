//
/* Enhanced Firefox user.js Configuration
 * Based on Betterfox with detailed comments and privacy enhancements
 * 
 * If you make changes to your about:config while the program is running, the
 * changes will be overwritten by the user.js when the application restarts.
 *
 * To make lasting changes to preferences, you will have to edit the user.js.
 */

/****************************************************************************
 * Betterfox                                                                *
 * "Ad meliora"                                                             *
 * version: 138                                                             *
 * url: https://github.com/yokoffing/Betterfox                              *
****************************************************************************/

/****************************************************************************
 * SECTION: FASTFOX - Performance Optimizations                            *
****************************************************************************/

/** GENERAL ***/
// Content notification interval in microseconds (100000 = 100ms)
// Higher values reduce CPU usage but may delay content updates
// Values: 100000 (default), 50000 (faster), 200000 (slower)
user_pref("content.notify.interval", 100000);

/** GFX - Graphics Acceleration ***/
// Canvas cache size in MB for hardware acceleration
// Higher values improve performance with canvas-heavy sites
// Values: 256, 512 (default), 1024
user_pref("gfx.canvas.accelerated.cache-size", 512);

// Font cache size in MB for Skia rendering
// Higher values reduce font rendering overhead
// Values: 10, 20 (default), 40
user_pref("gfx.content.skia-font-cache-size", 20);

/** DISK CACHE ***/
// Disable disk cache to improve performance and privacy
// Forces everything to use memory cache instead
// Values: true (enable disk cache), false (disable - recommended for privacy)
user_pref("browser.cache.disk.enable", false);

/** MEMORY CACHE ***/
// Maximum number of pages kept in session history for back/forward
// Lower values save memory, higher values improve back/forward speed
// Values: 2, 4 (default), 8, -1 (unlimited)
user_pref("browser.sessionhistory.max_total_viewers", 4);

/** MEDIA CACHE ***/
// Maximum media cache size in KB
// Higher values improve media playback but use more memory
// Values: 32768, 65536 (default), 131072
user_pref("media.memory_cache_max_size", 65536);

// Media cache readahead limit in seconds
// How much media to buffer ahead
// Values: 3600, 7200 (default), 14400
user_pref("media.cache_readahead_limit", 7200);

// Media cache resume threshold in seconds
// When to resume caching after pause
// Values: 1800, 3600 (default), 7200
user_pref("media.cache_resume_threshold", 3600);

/** IMAGE CACHE ***/
// Bytes decoded per iteration for images
// Higher values improve image loading speed
// Values: 16384, 32768 (default), 65536
user_pref("image.mem.decode_bytes_at_a_time", 32768);

/** NETWORK ***/
// Maximum total HTTP connections
// Higher values improve parallel loading
// Values: 900, 1800 (default), 2700
user_pref("network.http.max-connections", 1800);

// Maximum persistent connections per server
// Higher values improve loading from single domains
// Values: 6 (default), 10 (current), 15
user_pref("network.http.max-persistent-connections-per-server", 10);

// Maximum urgent connections per host
// Balances performance vs server load
// Values: 3, 5 (default), 10
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5);

// Disable HTTP request pacing for better performance
// May increase server load but improves speed
// Values: true (enable pacing), false (disable - faster)
user_pref("network.http.pacing.requests.enabled", false);

// DNS cache expiration in seconds
// Higher values reduce DNS lookups but may use stale data
// Values: 60, 3600 (default), 86400
user_pref("network.dnsCacheExpiration", 3600);

// SSL token cache capacity
// Higher values improve HTTPS performance
// Values: 2048, 10240 (default), 20480
user_pref("network.ssl_tokens_cache_capacity", 10240);

/** SPECULATIVE LOADING - Disabled for Privacy ***/
// Disable speculative parallel connections
// Prevents unnecessary connections that leak browsing data
// Values: 0 (disabled), 6 (default)
user_pref("network.http.speculative-parallel-limit", 0);

// Disable DNS prefetching to prevent privacy leaks
// Stops Firefox from resolving DNS for links you haven't clicked
// Values: true (disable), false (enable - default)
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);

// Disable speculative connections from URL bar
// Prevents connections when typing in address bar
// Values: true (enable), false (disable - privacy)
user_pref("browser.urlbar.speculativeConnect.enabled", false);

// Disable speculative connections from bookmarks/history
// Values: true (enable), false (disable - privacy)
user_pref("browser.places.speculativeConnect.enabled", false);

// Disable link prefetching
// Prevents downloading linked pages before clicking
// Values: true (enable), false (disable - privacy)
user_pref("network.prefetch-next", false);

// Disable network predictor
// Stops Firefox from predicting network requests
// Values: true (enable), false (disable - privacy)
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);

/** EXPERIMENTAL ***/
// Enable CSS Grid masonry layout
// Experimental feature for advanced layouts
// Values: true (enable), false (disable)
user_pref("layout.css.grid-template-masonry-value.enabled", true);

/****************************************************************************
 * SECTION: SECUREFOX - Security & Privacy Enhancements                    *
****************************************************************************/

/** TRACKING PROTECTION ***/
// Use strict content blocking for maximum privacy
// Blocks trackers, fingerprinters, cryptominers, and social media trackers
// Values: "standard", "strict" (recommended), "custom"
user_pref("browser.contentblocking.category", "strict");

// Download files to temp directory first (security)
// Prevents malicious files from being saved directly
// Values: true (secure), false (direct download)
user_pref("browser.download.start_downloads_in_tmp_dir", true);

// Delete temporary files on exit
// Improves privacy by removing traces
// Values: true (clean), false (keep)
user_pref("browser.helperApps.deleteTempFileOnExit", true);

// Disable UI tours (reduces attack surface)
// Values: true (enable), false (disable - recommended)
user_pref("browser.uitour.enabled", false);

// Enable Global Privacy Control header
// Tells websites not to sell/share your data
// Values: true (enable - recommended), false (disable)
user_pref("privacy.globalprivacycontrol.enabled", true);

/** OCSP & CERTS / HPKP ***/
// Disable OCSP to prevent certificate validation leaks
// May reduce security but improves privacy
// Values: 0 (disabled), 1 (enabled), 2 (required)
user_pref("security.OCSP.enabled", 0);

// Use CRLite for certificate validation
// Better privacy than OCSP while maintaining security
// Values: 0 (disabled), 1 (enabled), 2 (enforced)
user_pref("security.pki.crlite_mode", 2);

/** SSL / TLS ***/
// Treat unsafe SSL renegotiation as broken
// Improves security against certain attacks
// Values: true (secure), false (permissive)
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);

// Show expert certificate error pages
// Provides more information about SSL errors
// Values: true (detailed), false (simple)
user_pref("browser.xul.error_pages.expert_bad_cert", true);

// Disable TLS 0-RTT data
// Prevents replay attacks but may slow initial connections
// Values: true (allow), false (disable - secure)
user_pref("security.tls.enable_0rtt_data", false);

/** DISK AVOIDANCE ***/
// Force media cache in memory during private browsing
// Prevents media files from being saved to disk
// Values: true (memory only), false (allow disk)
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);

// Session store interval in milliseconds
// How often Firefox saves session data
// Values: 15000 (default), 60000 (current - less frequent)
user_pref("browser.sessionstore.interval", 60000);

/** SHUTDOWN & SANITIZING ***/
// Reset private browsing mode on restart
// Ensures complete cleanup of private sessions
// Values: true (reset), false (preserve)
user_pref("browser.privatebrowsing.resetPBM.enabled", true);

// Enable custom history settings
// Required for granular history control
// Values: true (custom), false (default)
user_pref("privacy.history.custom", true);

/** SEARCH / URL BAR ***/
// Trim HTTPS from URL bar display
// Cleaner appearance while maintaining security
// Values: true (trim), false (show full URL)
user_pref("browser.urlbar.trimHttps", true);

// Show full URL when interacting with address bar
// Values: true (show on interaction), false (always trimmed)
user_pref("browser.urlbar.untrimOnUserInteraction.featureGate", true);

// Enable separate private search engine selection
// Values: true (separate engines), false (same engine)
user_pref("browser.search.separatePrivateDefault.ui.enabled", true);

// Enable search engine alias refresh
// Values: true (enable), false (disable)
user_pref("browser.urlbar.update2.engineAliasRefresh", true);

// Disable search suggestions for privacy
// Prevents queries from being sent to search engines while typing
// Values: true (enable), false (disable - privacy)
user_pref("browser.search.suggest.enabled", false);

// Disable Firefox Suggest quick suggestions
// Prevents data sharing with Mozilla/partners
// Values: true (enable), false (disable - privacy)
user_pref("browser.urlbar.quicksuggest.enabled", false);

// Disable URL bar group labels
// Values: true (show labels), false (hide)
user_pref("browser.urlbar.groupLabels.enabled", false);

// Disable form autofill for privacy
// Prevents form data from being stored
// Values: true (enable), false (disable - privacy)
user_pref("browser.formfill.enable", false);

// Show punycode for internationalized domain names
// Security feature to prevent domain spoofing
// Values: true (show punycode - secure), false (show unicode)
user_pref("network.IDN_show_punycode", true);

/** PASSWORDS ***/
// Disable formless password capture
// Prevents capturing passwords from non-form elements
// Values: true (enable), false (disable - recommended)
user_pref("signon.formlessCapture.enabled", false);

// Disable password capture in private browsing
// Values: true (enable), false (disable - privacy)
user_pref("signon.privateBrowsingCapture.enabled", false);

// Allow HTTP auth for subresources
// Values: 1 (allow), 2 (disallow)
user_pref("network.auth.subresource-http-auth-allow", 1);

// Don't truncate user pastes
// Useful for long passwords/tokens
// Values: true (truncate), false (don't truncate)
user_pref("editor.truncate_user_pastes", false);

/** MIXED CONTENT + CROSS-SITE ***/
// Block mixed content display
// Prevents HTTP content on HTTPS pages
// Values: true (block - secure), false (allow)
user_pref("security.mixed_content.block_display_content", true);

// Disable JavaScript in PDFs
// Security measure to prevent PDF-based attacks
// Values: true (enable JS), false (disable - secure)
user_pref("pdfjs.enableScripting", false);

/** EXTENSIONS ***/
// Control extension installation scopes
// Values: 5 (current), 1 (profile only), 15 (all scopes)
user_pref("extensions.enabledScopes", 5);

/** HEADERS / REFERERS ***/
// Trim cross-origin referer headers
// Privacy enhancement - only send origin for cross-site requests
// Values: 0 (full URL), 1 (scheme+host+port+path), 2 (scheme+host+port)
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

/** CONTAINERS ***/
// Enable container tabs UI
// Allows compartmentalization of browsing sessions
// Values: true (enable), false (disable)
user_pref("privacy.userContext.ui.enabled", true);

/** SAFE BROWSING ***/
// Disable remote safe browsing downloads
// Prevents sharing download info with Google
// Values: true (enable), false (disable - privacy)
user_pref("browser.safebrowsing.downloads.remote.enabled", false);

/** GEOLOCATION - MAXIMUM PRIVACY ***/
// Block geolocation requests by default
// Values: 0 (always ask), 1 (allow), 2 (block)
user_pref("permissions.default.geo", 2);

// Disable geoclue (Linux geolocation service)
// Values: true (enable), false (disable - privacy)
user_pref("geo.provider.use_geoclue", false);

// Disable location services entirely
// Values: true (enable), false (disable - maximum privacy)
user_pref("geo.enabled", false);

// Clear location provider URL
user_pref("geo.provider.network.url", "");

// Disable Wi-Fi geolocation
user_pref("geo.wifi.uri", "");

/** MOZILLA CONNECTIONS ***/
// Block desktop notifications by default
// Values: 0 (always ask), 1 (allow), 2 (block)
user_pref("permissions.default.desktop-notification", 2);

// Disable search engine updates
// Values: true (enable), false (disable)
user_pref("browser.search.update", false);

// Clear default permissions URL
user_pref("permissions.manager.defaultsUrl", "");

// Disable add-on repository cache
// Values: true (enable), false (disable - privacy)
user_pref("extensions.getAddons.cache.enabled", false);

/** TELEMETRY - COMPLETE DISABLE ***/
// Disable all data submission to Mozilla
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("datareporting.usage.uploadEnabled", false);

/** EXPERIMENTS ***/
// Disable Shield studies
// Values: true (enable), false (disable - privacy)
user_pref("app.shield.optoutstudies.enabled", false);

// Disable Normandy recipe system
// Values: true (enable), false (disable - privacy)
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

/** CRASH REPORTS ***/
// Disable crash reporting
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);

/****************************************************************************
 * SECTION: PESKYFOX - UI & UX Improvements                                *
****************************************************************************/

/** MOZILLA UI ***/
// Disable VPN promotion URLs
user_pref("browser.privatebrowsing.vpnpromourl", "");

// Hide add-ons recommendations pane
// Values: true (show), false (hide)
user_pref("extensions.getAddons.showPane", false);

// Disable add-on recommendations
// Values: true (enable), false (disable)
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// Disable Firefox Discovery
// Values: true (enable), false (disable)
user_pref("browser.discovery.enabled", false);

// Don't check if Firefox is default browser
// Values: true (check), false (don't check)
user_pref("browser.shell.checkDefaultBrowser", false);

// Disable CFR (Contextual Feature Recommender)
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

// Hide "More from Mozilla" in preferences
// Values: true (show), false (hide)
user_pref("browser.preferences.moreFromMozilla", false);

// Don't show about:config warning
// Values: true (show warning), false (skip warning)
user_pref("browser.aboutConfig.showWarning", false);

// Disable welcome screen
// Values: true (show), false (hide)
user_pref("browser.aboutwelcome.enabled", false);

// Enable Firefox profiles
// Values: true (enable), false (disable)
user_pref("browser.profiles.enabled", true);

/** THEME ADJUSTMENTS ***/
// Enable userChrome.css support
// Allows custom CSS styling of Firefox interface
// Values: true (enable), false (disable)
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Show compact mode option
// Values: true (show option), false (hide)
user_pref("browser.compactmode.show", true);

// Disable private window separation (Windows)
// Values: true (separate), false (don't separate)
user_pref("browser.privateWindowSeparation.enabled", false);

/** FULLSCREEN NOTICE ***/
// Remove fullscreen transition delays
user_pref("full-screen-api.transition-duration.enter", "0 0");
user_pref("full-screen-api.transition-duration.leave", "0 0");

// Disable fullscreen warning timeout
// Values: 0 (no warning), 3000 (default - 3 seconds)
user_pref("full-screen-api.warning.timeout", 0);

/** URL BAR ***/
// Enable unit conversion in URL bar
// Values: true (enable), false (disable)
user_pref("browser.urlbar.unitConversion.enabled", true);

// Disable trending searches
// Values: true (enable), false (disable - privacy)
user_pref("browser.urlbar.trending.featureGate", false);

// Enable text fragments
// Values: true (enable), false (disable)
user_pref("dom.text_fragments.create_text_fragment.enabled", true);

/** NEW TAB PAGE ***/
// Clear default top sites
user_pref("browser.newtabpage.activity-stream.default.sites", "");

// Disable sponsored top sites
// Values: true (show), false (hide)
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Disable Pocket stories section
// Values: true (show), false (hide)
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

// Disable sponsored content
// Values: true (show), false (hide)
user_pref("browser.newtabpage.activity-stream.showSponsored", false);

/** POCKET ***/
// Disable Pocket integration
// Values: true (enable), false (disable)
user_pref("extensions.pocket.enabled", false);

/** DOWNLOADS ***/
// Don't add downloads to recent documents
// Values: true (add), false (don't add - privacy)
user_pref("browser.download.manager.addToRecentDocs", false);

/** PDF ***/
// Don't open PDF attachments inline
// Values: true (open inline), false (download)
user_pref("browser.download.open_pdf_attachments_inline", false);

/** TAB BEHAVIOR ***/
// Keep bookmark menu open when opening in tab
// Values: true (close menu), false (keep open)
user_pref("browser.bookmarks.openInTabClosesMenu", false);

// Show "View Image Info" in context menu
// Values: true (show), false (hide)
user_pref("browser.menu.showViewImageInfo", true);

// Highlight all matches in find bar
// Values: true (highlight all), false (highlight current)
user_pref("findbar.highlightAll", true);

// Don't select space when double-clicking words
// Values: true (select space), false (don't select)
user_pref("layout.word_select.eat_space_to_next_word", false);

/****************************************************************************
 * SECTION: ENHANCED PRIVACY & FINGERPRINTING PROTECTION                   *
****************************************************************************/

/** FINGERPRINTING RESISTANCE ***/
// Enable comprehensive fingerprinting protection
// This may break some sites but provides maximum privacy
// Values: true (enable - maximum privacy), false (disable)
user_pref("privacy.resistFingerprinting", true);

// Spoof timezone to UTC when fingerprinting resistance is enabled
// Values: true (spoof), false (use real timezone)
user_pref("privacy.resistFingerprinting.spoofTimeZone", true);

// Block fingerprinting in all modes
// Values: true (block), false (allow)
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);

// Disable WebGL for fingerprinting protection
// May break some websites and games
// Values: true (enable WebGL), false (disable - privacy)
user_pref("webgl.disabled", true);

// Disable Canvas fingerprinting
// Values: true (enable canvas), false (disable - privacy)
user_pref("gfx.canvas.hide_fingerprinting", true);

// Disable font fingerprinting
user_pref("browser.display.use_document_fonts", 0);

/** HISTORY & DATA RETENTION - NON-PERSISTENT HISTORY ***/
// Clear history when Firefox closes
user_pref("privacy.sanitize.sanitizeOnShutdown", true);

// Specify what to clear on shutdown (everything except logins)
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.cookies", false);  // Keep cookies for persistent logins
user_pref("privacy.clearOnShutdown.downloads", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.history", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.sessions", false);  // Keep sessions for tabs
user_pref("privacy.clearOnShutdown.siteSettings", false);  // Keep site permissions

// Don't remember browsing history
// Values: 0 (remember), 1 (never remember), 2 (custom)
user_pref("places.history.enabled", false);

// Disable location bar suggestions from history
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.bookmark", true);  // Keep bookmarks
user_pref("browser.urlbar.suggest.openpage", false);

/** COOKIE & SESSION MANAGEMENT ***/
// Keep cookies until they expire (for persistent logins)
// Values: 0 (until expiry), 1 (until browser close), 2 (accept for session), 3 (never accept)
user_pref("network.cookie.lifetimePolicy", 0);

// Accept cookies from visited sites only
// Values: 0 (accept all), 1 (accept from originating server only), 2 (never accept), 3 (visited only)
user_pref("network.cookie.cookieBehavior", 1);

// Enable same-site cookie protection
// Values: 0 (disabled), 1 (enabled)
user_pref("network.cookie.sameSite.laxByDefault", true);

/** PERMISSIONS & SITE DATA ***/
// Block camera access by default
// Values: 0 (always ask), 1 (allow), 2 (block)
user_pref("permissions.default.camera", 2);

// Block microphone access by default
// Values: 0 (always ask), 1 (allow), 2 (block)  
user_pref("permissions.default.microphone", 2);

// Block autoplay media
// Values: 0 (allow), 1 (block audio), 2 (block all), 5 (block all with exceptions)
user_pref("media.autoplay.default", 5);

// Disable push notifications by default
// Values: 0 (always ask), 1 (allow), 2 (block)
user_pref("dom.push.enabled", false);

// Disable service workers (may break some modern websites)
// Values: true (enable), false (disable - privacy)
user_pref("dom.serviceWorkers.enabled", false);

/****************************************************************************
 * START: MY OVERRIDES                                                      *
****************************************************************************/
// visit https://github.com/yokoffing/Betterfox/wiki/Common-Overrides
// visit https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening
// Enter your personal overrides below this line:

// Example: If you want to re-enable WebGL for specific sites:
// user_pref("webgl.disabled", false);

// Example: If you want to allow geolocation for specific trusted sites:
// You would need to set permissions manually in Firefox for those sites

// Example: If some sites break with fingerprinting resistance:
// user_pref("privacy.resistFingerprinting", false);

/****************************************************************************
 * SECTION: SMOOTHFOX                                                       *
****************************************************************************/
// visit https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
// Enter your scrolling overrides below this line:

// Example smooth scrolling preferences:
// user_pref("general.smoothScroll", true);
// user_pref("mousewheel.min_line_scroll_amount", 10);
// user_pref("general.smoothScroll.mouseWheel.durationMinMS", 80);

/****************************************************************************
 * END: BETTERFOX                                                           *
****************************************************************************/
