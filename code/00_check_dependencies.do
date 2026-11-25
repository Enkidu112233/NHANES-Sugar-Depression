* Called by the master entry in analysis and full modes.
* Prefer the optional, project-local author distribution when provided.
local depdir "$root/vendor/gologit2"
capture confirm file "`depdir'/gologit2.ado"
if !_rc {
    foreach file in gologit2 gsvy gologit2_svy gologit2_svy_check gologit2_ll gologit2_p gologit2_lincom gologit2_autofit {
        capture confirm file "`depdir'/`file'.ado"
        if _rc {
            display as error "Incomplete local gologit2 package: missing `file'.ado. See README.md."
            exit 601
        }
    }
    adopath ++ "`depdir'"
}

* Refresh automatically loaded commands so an older cached version cannot take precedence.
discard
foreach cmd in gologit2 gsvy {
    capture which `cmd'
    if _rc {
        display as error "Required Stata command `cmd' was not found. See the gologit2 setup in README.md."
        exit 111
    }
    which `cmd'
}
