// This file can be used to configure global preferences for Firefox

// Defaults für den Firefox findet man hier:
//
// * resource:///defaults/preferences/firefox.js
// * https://dxr.mozilla.org/mozilla-release/source/browser/app/profile/firefox.js
//
// Es gibt meist aber noch *brandigs* bzw. Ergänzungen
//
// * resource:///defaults/preferences/  (das Backslash am Ende ist erforderlich)

// Firefox Sync-1.5 Server
// -----------------------

pref(
    "identity.sync.tokenserver.uri"
    , "https://storage/fxSyncServer/token/1.0/sync/1.5");

// Homepage
// -------

// Der Standard ist "about:home", das hängt an dem "about:home" Konzept (siehe
// unten). Bei mir lies sich die Homepage nur einstellen, wenn ich mit lockPref
// den Wert gesetzt hab. Ansonsen hat FFox bei mir immerwieder das "about:home"
// reingehängt. Mit dem lockPref kann allerdings der Benutzer keine individuelle
// Homepage mehr setzen, dass gefällt mir eigentlich auch nicht, aber bei mir
// überwiegt die Entscheidung gegen "about:home". Bei Konzept landet man mit
// jedem Start des FFox erst mal auf den Mozilla Servern und man hat beim Start
// immer eine *Suchmaschine*, die "wer anders" für einen ausgesucht hat. Das ist
// auch nicht groß anderes als hier eine Suchmaschine als unveränderbare
// Startseite einzutragen ;-)

// funktioniert nicht mehr seit 20180105
//pref("browser.startup.homepage", "http://darmarIT.de");

// Usage
// -----

// Self-Signed Zertifikate kommen bei mir öfters vor, deswegen den Button dafür
// gleich in die Warnmeldung einbauen.
//
// * https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/Mozilla_preferences_for_uber-geeks#Security_preferences
//
// zuletzt getestet: 20181005
pref("browser.xul.error_pages.expert_bad_cert", true);

// Safebrowsing
// ------------

// Safebrowsing schützt vor Pishing-Angriffen. Die Lösung von Google hat jedoch
// den Nacheil, dass sie die Privatsphäre eklatant verletzt.  Durch Nutzung von
// Safebrowsing willigt man automatisch in die `Google Privacy Policy
// <http://www.google.com/policies/privacy/>`_ ein.  Zusätzlich werden beim
// Safe-Browsing Cookies gesetzt (siehe `Information Google receives when you
// use the Safe Browsing feature on Chrome or other browsers
// <https://www.google.com/intl/en/chrome/browser/privacy/>`_).  Diese Cookies
// (so munkelt man) sollen es der NSA ermöglichen Rechner im Internet eindeutig
// zu identifizieren.  Seit Snowden glaube ich das die Realität noch krasser ist
// als die Gerüchteküche es vermuten lässt. --> abschalten!
//
// * Wikipedia : https://en.wikipedia.org/wiki/Google_Safe_Browsing
// * Mozilla : https://wiki.mozilla.org/Safe_Browsing
//
// Hier wird Safebrowsing abgeschaltet, wir haben dafür das uBlock Origin
// AddOn installiert.

pref("browser.safebrowsing.malware.enabled",            false);
pref("browser.safebrowsing.phishing.enabled",           false);
pref("browser.safebrowsing.downloads.enabled",          false);

// den google provider ganz löschen ...
pref("browser.safebrowsing.provider.google.gethashURL", "");
pref("browser.safebrowsing.provider.google.lists",      "");
pref("browser.safebrowsing.provider.google.reportURL",  "");
pref("browser.safebrowsing.provider.google.updateURL",  "");


// Privatsphäre
// ------------

// https://github.com/amq/firefox-debloat
pref("datareporting.healthreport.infoURL",              "");
pref("datareporting.healthreport.uploadEnabled",        false);
pref("browser.tabs.crashReporting.sendReport",          false);

pref("toolkit.telemetry.unified",                       false);
pref("toolkit.telemetry.enabled",                       false);
pref("privacy.trackingprotection.enabled",                  true);

pref("extensions.pocket.enabled",                       false);
pref("browser.search.suggest.enabled",                  false);
pref("geo.enabled",                                         false);
pref("plugin.state.flash",                              false);

// pref("media.peerconnection.enabled",                    false);
pref("media.peerconnection.ice.default_address_only",   true);


lockPref("loop.enabled",                                    false);



// about:home
// ----------

// Ich find das about:home Konzept ziemlich fragwürdig. Wozu braucht man das,
// man kann sich doch (als Vendor) eine eigene WEB-Seite machen und die als
// Startseite im Firefox setzen.
//
// Die Sourcen: mxr.mozilla.org/mozilla-release/source/browser/modules/AboutHome.jsm
//
// Keine Ahnung, was da passiert, aber so was gefällt mir nicht:
//
// * https://groups.google.com/forum/?fromgroups=#!topic/mozilla.governance/A4eNbXdW1uk
//
// """when the user opens the about:home page, Firefox desktop will send the
//    browser’s IP address to this internal service, and the service will return
//    the name of the country the user is located in.  The browser will store
//    the country name in localStorage.  Note that it is the actual country name
//    that is being stored – NOT the IP address.  The IP address is not stored
//    after country is established on either the client or server ..."""

pref("browser.aboutHomeSnippets.updateUrl", "nonexistent://test");

// FIXME: about:home speichert noch eine Snipptsammlung in der DB, die muss man
// löschen:
// * https://support.mozilla.org/en-US/questions/1004495

// Searchengines
// -------------
//
// Das ist ein ziemliches Durcheinander, oder ich versteh es nur einfach nicht.
//
// Die Searchengines werden einmal über die Distribution des FF installiert
//
// * /usr/lib/firefox/distribution/searchplugins/locale/*/amazondotcom*.xml
//
// und dann kommen die Searchengines auch nochmal mit jedem language-Pack.
//
// * /usr/lib/firefox-addons/extensions/langpack-de@firefox.mozilla.org.xpi
//
// und zu guter Letzt hat canonical dann in dem firefox-locale-XX Paketen noch
// die Searchengines amazondotcom.xml, ddg.xml, google.xml gepakt, die aber
// nicht lokalisiert sind sondern nur Kopien der standard Suchen sind in denen
// sie ihr beklopptes Vendor-Tag eingebaut wurde .. mit dem Effekt, das man bei
// DuckDuck Go *englische* Treffer on Top sieht ... grrr.
//
// Notizen zu meiner Sourcecode Analyse
// ------------------------------------
//
// * Regionale Settings: chrome://browser-region/locale/region.properties
//
// * Dokumentierte Sourcen zu den *standard* FF Settings:
//   https://dxr.mozilla.org/mozilla-release/source/browser/app/profile/firefox.js
//
// Die Funktion *Searchengines* werden über diese Resource angeboten:
//
// * resource://gre/components/nsSearchService.js
// * http://dxr.mozilla.org/mozilla-release/source/toolkit/components/search/nsSearchService.js
//
// Anzeigen des Propertie Namens für die default-engine::
//
//    nsSearchService = Components.utils.import("resource://gre/components/nsSearchService.js");
//    nsSearchService.getGeoSpecificPrefName("browser.search.defaultenginename")
//    nsSearchService.geoSpecificDefaultsEnabled()
//
// FFox baut eine liste der *sortierten* Suchmaschinen mit der Funktion
// nsSearchService.SearchService.prototype._buildSortedEngineList auf:
//
// * https://dxr.mozilla.org/mozilla-release/search?q=_buildSortedEngineList
//
// Diese Funktion ist die zentrale Stelle zum Aufbau der *ordered* Listen der
// Searchengines. Und der ganze geoSpecific-Kram scheint mir buggy oder
// zumindest missverständlich zu sein.  Zumindest scheint mir die
// getGeoSpecificPrefName:
//
// * https://dxr.mozilla.org/mozilla-release/search?q=getGeoSpecificPrefName
//
// völlig überflüssig zu sein, sie liefert jedenfalls nicht das, was der Name
// einen glauben lässt. Der Returnwert ist immer der Eingabewert, nur bei US
// wird was drangeklebt.
//
// Verschiedenes:
//
// * https://dxr.mozilla.org/mozilla-release/search?q=geoSpecificDefaultsEnabled

// Aus dem Durcheinander versuche ich jetzt mal was vernüftiges zu konfigurieren

pref("browser.search.isUS", false); // spätestens jetzt ist getGeoSpecificPrefName komplett überflüssig

pref("browser.search.geoSpecificDefaults", true);
pref("general.useragent.locale", "de");

pref("browser.search.defaultenginename",      "DuckDuckGo");

// Die Browser-Settings
//    https://dxr.mozilla.org/mozilla-release/search?q=browser.search.order
// FIXME: die funktionieren nicht mehr?
//
// pref("browser.search.order.1",                "DuckDuckGo");
// pref("browser.search.order.2",                "Google");
// pref("browser.search.order.3",                "Yahoo");

// Die .extra.n Settings nimmt er an ?!?!?
//
// pref("browser.search.order.extra.1",          "DuckDuckGo");
// pref("browser.search.order.extra.2",          "Google");
