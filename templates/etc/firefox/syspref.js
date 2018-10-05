// This file can be used to configure global preferences for Firefox

// Defaults für den Firefox findet man hier:
//
// * resource:///defaults/preferences/firefox.js
// * http://mxr.mozilla.org/mozilla-release/source/browser/app/profile/firefox.js
//
// Es gibt meist aber noch *brandigs* bzw. Ergänzungen
//
// * resource:///defaults/preferences/  (das Backslash am Ende ist erforderlich)

// Firefox Sync-1.5 Server
// -----------------------

lockPref(
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

//pref("browser.startup.homepage", "http://darmarIT.de");

// DuckDuckGo-DE-dark
// lockPref("browser.startup.homepage"
//          , "https://duckduckgo.com/?kn=1&kad=de_DE&kl=de-de&kae=d&k8=ffb&kj=aaa&kd=1&k5=1&kak=-1&kal=-1&kai=1&kt=n&ks=l&kw=s&");

// DuckDuckGo-DE-bright
lockPref("browser.startup.homepage"
         , "https://duckduckgo.com/?kn=1&kad=de_DE&kl=de-de&kd=1&k5=1&kak=-1&kal=-1&kai=1&ks=l&kw=s&");

// Usage
// -----

// Self-Signed Zertifikate kommen bei mir öfters vor, deswegen den Button dafür
// gleich in die Warnmeldung einbauen.
//
// * https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/Mozilla_preferences_for_uber-geeks#Security_preferences
//
pref("browser.xul.error_pages.expert_bad_cert", true);

// Safebrowsing
// ------------

// Safebrowsing schützt vor Pishing-Angriffen. Die Lösung von Google hat jedoch
// den Nacheil, dass sie eklatant die Privatsphäre verletzt.  Durch Nutzung von
// Safebrowsing willigt man automatisch in die `Google Privacy Policy
// <http://www.google.com/policies/privacy/>`_ ein. Zusätzlich werden beim
// Safe-Browsing Cookies gesetzt (siehe `Information Google receives when you
// use the Safe Browsing feature on Chrome or other browsers
// <https://www.google.com/intl/en/chrome/browser/privacy/>`_). Diese Cookies
// (so munkelt man) sollen es der NSA ermöglichen sollen Rechner im Internet
// eindeutig zu identifizieren. Seit Snowden glaube ich das die Realität noch
// krasser ist als die Gerüchteküche es vermuten lässt. --> abschalten!
//
// * Wikipedia : https://en.wikipedia.org/wiki/Google_Safe_Browsing
// * Mozilla : https://wiki.mozilla.org/Safe_Browsing
//
// Als Alternative empfiehlt sich uBlock Origin
//
// * https://github.com/gorhill/uBlock
// * https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/

lockPref("browser.safebrowsing.enabled",                    false);
lockPref("browser.safebrowsing.malware.enabled",            false);
lockPref("browser.safebrowsing.downloads.enabled",          false);

// den google provider ganz löschen ...
lockPref("browser.safebrowsing.appRepURL", "");
lockPref("browser.safebrowsing.provider.google.gethashURL", "");
lockPref("browser.safebrowsing.provider.google.lists",      "");
lockPref("browser.safebrowsing.provider.google.reportURL",  "");
lockPref("browser.safebrowsing.provider.google.updateURL",  "");

// Privatsphäre
// ------------

// https://github.com/amq/firefox-debloat
lockPref("datareporting.healthreport.service.enabled",      false);
lockPref("datareporting.healthreport.uploadEnabled",        false);
lockPref("toolkit.telemetry.unified",                       false);
lockPref("toolkit.telemetry.enabled",                       false);
lockPref("loop.enabled",                                    false);
lockPref("browser.pocket.enabled",                          false);
pref("browser.search.suggest.enabled",                      false);
//pref("media.peerconnection.enabled",                        false);
lockPref("media.peerconnection.ice.default_address_only",   true);
pref("geo.enabled",                                         false);
lockPref("plugin.state.flash",                              false);
pref("privacy.trackingprotection.enabled",                  true);

lockPref("browser.tabs.crashReporting.sendReport",          false);

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

lockPref("browser.aboutHomeSnippets.updateUrl", "nonexistent://test");

// FIXME: about:home speichert noch eine Snipptsammlung in der DB, die muss man
// löschen:
// * https://support.mozilla.org/en-US/questions/1004495



// DuckDuck Go Searchengine (de-dark)
// ---------------------------------

// Bei der DDG Searchengine hat man immer die englischen defaults, ich hab mir
// deshalb eine mit den deutschen Voreinstellungen und einem *dark* Theme gebaastelt:
//
// * TEMPLATES/usr/lib/firefox/distribution/searchplugins/locale/de/ddg-de-dark.xml

// Searchengines
// -------------

// Das ist ein ziemliches Durcheinander, oder ich versteh ees nur einfach
// nicht. Mein Eindruck: man wollte sich konkurierende Anforderungen umsetzen:
//
// * Der Benutzer soll sich seine eigenen Werte einstellen, die werden in einer
//   DB gespeichert
//
// * Es werden defaults in den Prefs gespeichert, diese können zusätzlich noch
//   um z.B. "DE" oder "EN" erweitert sein (*getGeoSpecificPrefName*).
//
// * Diese defaults sollen sich die Distributoren (zu erkennen an der
//   "distribution.id") selber einstellen können.
//
// * Mozilla will eigene defaults setzen ("distribution.id"=="mozilla...")
//
// * Es soll fallbacks geben, falls obiges alles nicht zutrifft.
//
// * Man kann noch die Sortierung über "browser.search.order.extra" eine
//   Sortierung präferieren .. und das kann dann auch nochmal mit Lang-Code
//   erweitert sein.
//
// Ich hab da nicht den kompletten Durchblick. Diese ganzen Anforderungen führen
// am Ende zu einem ziemlichen Durcheinander, wenn man als Admin versucht ein
// vernüftiges Setup in seinen syspref.js zu konfigurieren. Man weiß eigentlich
// nie, was vom FF an Einstellungen angezogen wird.
//
// Hinzu kommt:
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
//   http://mxr.mozilla.org/mozilla-release/source/browser/app/profile/firefox.js
//
// Die Funktion *Searchengines* werden über diese Resource angeboten:
//
// * resource://gre/components/nsSearchService.js
// * http://mxr.mozilla.org/mozilla-release/source/toolkit/components/search/nsSearchService.js
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
// * http://mxr.mozilla.org/mozilla-release/ident?i=_buildSortedEngineList
//
// Diese Funktion ist die zentrale Stelle zum Aufbau der *ordered* Listen der
// Searchengines. Und der ganze geoSpecific-Kram scheint mir buggy oder
// zumindest missverständlich zu sein.  Zumindest scheint mir die
// getGeoSpecificPrefName:
//
// * http://mxr.mozilla.org/mozilla-release/ident?i=getGeoSpecificPrefName
//
// völlig überflüssig zu sein, sie liefert jedenfalls nicht das, was der Name
// einen glauben lässt. Der Returnwert ist immer der Eingabewert, nur bei US
// wird was drangeklebt.
//
// Verschiedenes:
//   * http://mxr.mozilla.org/mozilla-release/ident?i=geoSpecificDefaultsEnabled


// Aus dem Durcheinander versuche ich jetzt mal was vernüftiges zu konfigurieren

pref("browser.search.isUS", false); // spätestens jetzt ist getGeoSpecificPrefName komplett überflüssig

// Die lokalisierten Settings nimmt er nicht an ....
//
// pref("browser.search.geoSpecificDefaults", true);
// pref("general.useragent.locale", "de");
// pref("browser.search.defaultenginename.DE",      "data:text/plain,browser.search.defaultenginename.DE=DuckDuckGo");
// pref("browser.search.order.DE.1",                "data:text/plain,browser.search.order.DE.1=DuckDuckGo");
// pref("browser.search.order.DE.2",                "data:text/plain,browser.search.order.DE.2=Google");
// pref("browser.search.order.DE.3",                "data:text/plain,browser.search.order.DE.3=Yahoo");

// Die nicht lokaliserten Settings ignoriert er auch
//
// pref("browser.search.geoSpecificDefaults", false);
// pref("browser.search.defaultenginename",      "DuckDuckGo");
// pref("browser.search.order.1",                "DuckDuckGo");
// pref("browser.search.order.2",                "Google");
// pref("browser.search.order.3",                "Yahoo");

// Die .extra.n Settings nimmt er an
//
// pref("browser.search.order.extra.1",          "DuckDuckGo");
lockPref("browser.search.order.extra.1",          "DuckDuckGo-DE-bright");
lockPref("browser.search.order.extra.2",          "DuckDuckGo-DE-dark");
logPref("browser.search.order.extra.3",          "Google");
//pref("browser.search.order.extra.4",          "Yahoo");

// für die default-searchengine gib es kein .extra
pref("browser.search.defaultenginename",      "DuckDuckGo-DE-bright");
//pref("browser.search.defaultenginename",      "DuckDuckGo");
