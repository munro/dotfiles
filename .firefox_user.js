user_pref("layout.spellcheckDefault", 0); // disable spell check as you type
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false); // disable picture in picture video controls
user_pref("browser.search.region", "US");
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false); // dont recommend addons
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false); // dont recommend features
user_pref("network.proxy.type", 0); // no proxy
user_pref("browser.startup.page", 3); // open previous pages and tabs

user_pref("extensions.pocket.enabled", false);

/***** IDK *****/
user_pref("network.dns.disableIPv6", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.predictor.enabled", false);
user_pref("network.prefetch-next", false);

/***** BLANK HOME PAGE *****/
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");
user_pref("browser.newtabpage.pinned", "[]");
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);

/***** NO Search suggestions *****/
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.shortcuts.bookmarks", false);
user_pref("browser.urlbar.shortcuts.history", false);
user_pref("browser.urlbar.shortcuts.tabs", false);
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.suggest.topsites", false);

/***** PRIVACY *****/
user_pref("browser.contentblocking.category", "custom");
user_pref("privacy.fingerprintingProtection", true);
user_pref("network.cookie.cookieBehavior", 5);
user_pref("privacy.trackingprotection.emailtracking.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.fingerprintingProtection.pbmode", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.emailtracking.pbmode.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.trackingprotection.pbmode.enabled", true);

/***** DELETE DAT AON SHUTDOWN *****/
user_pref("pref.privacy.disable_button.cookie_exceptions", false);
user_pref("privacy.clearOnShutdown.downloads", false);
user_pref("privacy.clearOnShutdown.formdata", false);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.sessions", false);
user_pref("privacy.history.custom", true);
user_pref(
    "privacy.sanitize.pending",
    '[{"id":"shutdown","itemsToClear":["cache","cookies","offlineApps"],"options":{}}]'
);
user_pref("privacy.sanitize.sanitizeOnShutdown", true);

/***** NO PASSWORD SUGGESR *****/
user_pref("signon.management.page.breach-alerts.enabled", false);
user_pref("signon.rememberSignons", false);

/***** NO AUTOFILL *****/
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

/***** CUSTOM HISTORY *****/
user_pref("privacy.history.custom", true);
user_pref(
    "privacy.sanitize.pending",
    '[{"id":"shutdown","itemsToClear":["cache","cookies","offlineApps"],"options":{}}]'
);
user_pref("places.history.enabled", true);
user_pref("browser.formfill.enable", true);
user_pref("privacy.sanitize.sanitizeOnShutdown", true);

/***** BLCOK NOTIFICATIONS *****/
user_pref("permissions.default.desktop-notification", 2);

/***** NO TELEMETRY *****/
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);

/*** DNS QUERY */
user_pref("doh-rollout.disable-heuristics", true);
user_pref("doh-rollout.home-region", "US");
user_pref("doh-rollout.uri", "https://mozilla.cloudflare-dns.com/dns-query");
user_pref("network.trr.mode", 3);
user_pref("network.trr.uri", "https://mozilla.cloudflare-dns.com/dns-query");
user_pref("network.trr.excluded-domains", "localhost,127.0.0.1");

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
user_pref("browser.compactmode.show", true);
user_pref("devtools.everOpened", true);
user_pref("browser.bookmarks.addedImportButton", false);
user_pref("browser.download.panel.shown", true);
user_pref("accessibility.typeaheadfind", true);
user_pref("accessibility.typeaheadfind.flashBar", 0);
user_pref("browser.bookmarks.restore_default_bookmarks", false);
user_pref("browser.translations.panelShown", true);
user_pref("browser.contentblocking.report.hide_vpn_banner", true);
user_pref("browser.fullscreen.autohide", true);
user_pref("browser.tabs.inTitlebar", 1);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("devtools.cache.disabled", true);
user_pref("dom.security.https_first", true);
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);
user_pref("dom.security.https_only_mode_ever_enabled_pbm", true);
// user_pref("extensions.ui.dictionary.hidden", true);
// user_pref("extensions.ui.lastCategory", "addons://list/extension");
// user_pref("extensions.ui.locale.hidden", true);
// user_pref("extensions.ui.plugin.hidden", false);
// user_pref("extensions.ui.sitepermission.hidden", true);
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.xr", 2);
user_pref("pref.privacy.disable_button.tracking_protection_exceptions", false);
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.resistFingerprinting.block_mozAddonManager", true);
user_pref("privacy.resistFingerprinting.randomization.daily_reset.enabled", true);
user_pref("privacy.resistFingerprinting.randomization.daily_reset.private.enabled", true);
