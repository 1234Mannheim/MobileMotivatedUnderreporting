 *----------------- (Do File for Motivated Underreporting in Mobile Surveys )------- *
capture log close 
clear all
set more off
cap log close

log using "$log/analysis.log", replace


* --------------- ( Data Preparation for Misreporting in Mobile Surveys Paper ) --------------- *

* load Unipark data * 

//use "H:\Aufgaben\JD\Koeffizientenplot\respondi_7.dta"

use "C:\Users\Wengrzja\ownCloud\Daikeler_MUMS\data\respondi_7.dta"

// as soon as we get the nonresp data keep socio demogr
keep   p_device lfdn - trigg_pseudo  device - device_own_andere_v e_G1_Kaffee - e_G2_Zufrieden_Putzzeug numinv2 -  size_residence Ausbildungsabschluss Einkommen_netto Einwohnerzahl diff diff2



destring , replace
numlabel _all, add

* define locals for Interleafed and Grouped filter questions*
global i_filt  e_G1_Kaffee e_G1_BierWein e_G1_Tabak e_G1_KleidungSchuhe e_G1_Schokolade e_G1_Medikamente e_G1_Blumen e_G1_Haustierprodukte e_G1_DVD_Video e_G1_CD_MP3 e_G1_Eintrittskarte e_G1_Putzzeug

global g_filt e_G2_Kaffee e_G2_BierWein e_G2_Tabakwaren e_G2_Kleidung e_G2_Schoki e_G2_Medikamente e_G2_Blumen e_G2_Haustier e_G2_DVD e_G2_CD e_G2_Eintritt e_G2_Putzzeug


* Interleafed vs. grouped format
** "1  G1 Grouped Format, 2  G2 Interleaved Format"
** "0  G1 Grouped Format, 1  G2 Interleaved Format"

tab trigg_filter, m
 
recode trigg_filter (1=0) (2=1)
 
 label define interleafed 0 "grouped" 1 "interleafed"
 label values trigg_filter interleafed
 

* PC vs. mobile
** 1 Desktop-PC oder Laptop  ; 2 Smartphone
describe p_device

destring p_device, replace
tab p_device,m

recode p_device (1=0) (2=1) 
drop if p_device == . // delete those rep who quit on respondi side 

*Edu in Dummy 
tab Ausbildungsabschluss

gen highedu=0
    replace highedu = 1 if Ausbildungsabschluss == 5 
  replace highedu = 1 if Ausbildungsabschluss == 6 
  replace highedu = 1 if Ausbildungsabschluss == 7 
  replace highedu = 1 if Ausbildungsabschluss == 8
   replace highedu = . if Ausbildungsabschluss == -77 
  replace highedu = . if Ausbildungsabschluss == 9

  tab highedu,m 
  
* Filter questions * 


tab1 e_G1_Kaffee e_G1_BierWein e_G1_Tabak e_G1_KleidungSchuhe e_G1_Schokolade e_G1_Medikamente e_G1_Blumen e_G1_Haustierprodukte e_G1_DVD_Video e_G1_CD_MP3 e_G1_Eintrittskarte e_G1_Putzzeug,m 
tab1 e_G2_Kaffee e_G2_BierWein e_G2_Tabakwaren e_G2_Kleidung e_G2_Schoki e_G2_Medikamente e_G2_Blumen e_G2_Haustier e_G2_DVD e_G2_CD e_G2_Eintritt e_G2_Putzzeug


*foreach var of global `i_filt' {
 *  tab `var' , m
* }


* Build one filter var 
* There are two Variable one in the interleafed one in the grouped I build an indicator for both mergeing them in to one 

** Coffee
gen e_Kaffee = e_G1_Kaffee
replace e_Kaffee=1 if e_G2_Kaffee==1  // is one if group 2 is 1 
replace e_Kaffee=2 if e_G2_Kaffee==2  // code no into  no 
replace e_Kaffee=2 if e_G2_Kaffee==0 //code weiss nicht into no 
replace e_Kaffee=2 if e_G1_Kaffee==0 // if they skipped question into no 
tab e_Kaffee, m 

tab e_Kaffee, m 

drop if e_Kaffee==-77



** Beer/Wine
gen e_BierWein = e_G1_BierWein
replace e_BierWein=1 if e_G2_BierWein==1 
replace e_BierWein=2 if e_G2_BierWein==2 
replace e_BierWein=2 if e_G2_BierWein==0 //code weiss nicht into no 
replace e_BierWein=2 if e_G1_BierWein==0

tab e_BierWein, m 

drop if e_BierWein==-77
drop if e_BierWein== 0


** Tobacco 
gen e_Tabak = e_G1_Tabak
replace e_Tabak=1 if e_G2_Tabakwaren==1 
replace e_Tabak=2 if e_G2_Tabakwaren==2
replace e_Tabak=2 if e_G2_Tabakwaren==0 //code weiss nicht into no 
replace e_Tabak=2 if e_G1_Tabak==0 
tab e_Tabak, m 

drop if e_Tabak==-77
drop if e_Tabak== 0

** Clothing
gen e_KleidungSchuhe = e_G1_KleidungSchuhe
replace e_KleidungSchuhe=1 if e_G2_Kleidung==1 
replace e_KleidungSchuhe=2 if e_G2_Kleidung==2 
replace e_KleidungSchuhe=2 if e_G2_Kleidung==0 //code weiss nicht into no 
replace e_KleidungSchuhe=2 if e_G1_KleidungSchuhe==0 
tab e_KleidungSchuhe, m 

drop if e_KleidungSchuhe==-77
drop if e_KleidungSchuhe== 0


** Chocolate
gen e_Schokolade = e_G1_Schokolade
replace e_Schokolade=1 if e_G2_Schoki==1 
replace e_Schokolade=2 if e_G2_Schoki==2 
replace e_Schokolade=2 if e_G2_Schoki==0 //code weiss nicht into no 
replace e_Schokolade=2 if e_G1_Schokolade==0 
tab e_Schokolade, m 

drop if e_Schokolade==-77
drop if e_Schokolade== 0




** Medication
gen e_Medikamente = e_G1_Medikamente
replace e_Medikamente=1 if e_G2_Medikamente==1 
replace e_Medikamente=2 if e_G2_Medikamente==2 
replace e_Medikamente=2 if e_G2_Medikamente==0 //code weiss nicht into no 
replace e_Medikamente=2 if e_G1_Medikamente==0 
tab e_Medikamente, m 

drop if e_Medikamente==-77
drop if e_Medikamente== 0



** Flowers
gen e_Blumen = e_G1_Blumen
replace e_Blumen=1 if e_G2_Blumen==1 
replace e_Blumen=2 if e_G2_Blumen==2 
replace e_Blumen=2 if e_G2_Blumen==0 //code weiss nicht into no 
replace e_Blumen=2 if e_G1_Blumen==0 
tab e_Blumen, m 

drop if e_Blumen==-77
drop if e_Blumen== 0 



**Pet supplies
gen e_haustier = e_G1_Haustierprodukte
replace e_haustier=1 if e_G2_Haustier==1 
replace e_haustier=2 if e_G2_Haustier==2 
replace e_haustier=2 if e_G2_Haustier==0 //code weiss nicht into no 
replace e_haustier=2 if e_G1_Haustierprodukte==0 
tab e_haustier, m 

drop if e_haustier == -77
drop if e_haustier == 0


** DVD/ Video 
gen e_DVD = e_G1_DVD_Video
replace e_DVD=1 if e_G2_DVD==1 
replace e_DVD=2 if e_G2_DVD==2 
replace e_DVD=2 if e_G2_DVD==0 //code weiss nicht into no 
replace e_DVD=2 if e_G1_DVD_Video==0 
tab e_DVD, m

drop if e_DVD == -77
drop if e_DVD == 0
 

** CD/ MP3 

gen e_CD = e_G1_CD_MP3
replace e_CD=1 if e_G2_CD==1 
replace e_CD=2 if e_G2_CD==2 
replace e_CD=2 if e_G2_CD==0 //code weiss nicht into no 
replace e_CD=2 if e_G1_CD_MP3==0 
tab e_CD, m 

drop if e_CD == -77
drop if e_CD == 0


** Tickets 
gen e_Eintrittskarte = e_G1_Eintrittskarte
replace e_Eintrittskarte=1 if e_G2_Eintritt==1 
replace e_Eintrittskarte=2 if e_G2_Eintritt==2 
replace e_Eintrittskarte=2 if e_G2_Eintritt==0 //code weiss nicht into no 
replace e_Eintrittskarte=2 if e_G1_Eintrittskarte==0 
tab e_Eintrittskarte, m 

drop if e_Eintrittskarte == -77
drop if e_Eintrittskarte == 0


** Cleaning supplies 
gen e_Putzzeug = e_G1_Putzzeug
replace e_Putzzeug=1 if e_G2_Putzzeug==1 
replace e_Putzzeug=2 if e_G2_Putzzeug==2 
replace e_Putzzeug=2 if e_G2_Putzzeug==0 //code weiss nicht into no 
replace e_Putzzeug=2 if e_G1_Putzzeug==0 
tab e_Putzzeug, m

drop if e_Putzzeug == -77
drop if e_Putzzeug == 0



** Defining  a local with all filter questions 
global filter "e_Kaffee e_Schokolade e_KleidungSchuhe e_Tabak e_BierWein e_Medikamente e_Blumen e_haustier e_DVD e_CD e_Putzzeug"
// `filter' 
summarize `filter'  

foreach var of varlist e_Kaffee e_Schokolade e_KleidungSchuhe e_Tabak e_BierWein e_Medikamente e_Blumen e_haustier e_DVD e_CD e_Putzzeug  {
recode `var'  (2=0) 

}

rename trigg_filter interleafed
tab interleafed


rename p_device mobile 

// Creating a variables which counts the number of YES in one of the 13 filter questions
* egen filterquest = anycount(`filter'), values(1)

egen filterquest = anycount(e_Kaffee e_Schokolade e_KleidungSchuhe e_Tabak e_BierWein e_Medikamente e_Blumen e_haustier e_DVD e_CD e_Putzzeug), values(1)


label variable filterquest "How often a filter quest was answered with YES"

tab filterquest, m // variable which indictates how often a person replied to a filter question with yes  (grouped or interleafed format) 

hist(filterquest)

// gen filter questuest without coffee because resp do not know in coffee question that will get follwo ups 

egen filterquest1 = anycount(e_Schokolade e_KleidungSchuhe e_Tabak e_BierWein e_Medikamente e_Blumen e_haustier e_DVD e_CD e_Putzzeug), values(1)

tab filterquest1, m // variable which indictates how often a person replied to a filter question with yes  (grouped or interleafed format) 

label variable filterquest1 "How often a filter quest (but not the first one) was answered with YES"





* Build indicators for straightlining and nonresponse in follow up  questions *
** Looking at the follow ups **
*** 3 follow ups for each filter quest***

* Bitte denken Sie an das letzte Mal als Sie Bier oder Wein gekauft haben. (q_10264181 - Typ 141) 
*DUMMY: Für wen haben Sie das Bier/den Wein gekauft? (q_10263274 - Typ 121) 
* CAT: Wie zufrieden sind Sie mit der Qualität des Bier oder Wein? (q_10263275 - Typ 111) 
* CAT and Open : Was haben Sie für das Bier/den Wein bezhalt?  (q_10263275 - Typ 111) 

** merge Zufriedenheit into one var  

*Coffee
clonevar ec_Zuf_Kaffee = e_G1_Zufrieden_Kaffee
replace ec_Zuf_Kaffee = e_G2_Zufrieden_Kaffee if ec_Zuf_Kaffee==-77

*Beer
clonevar ec_Zuf_Bier = e_G1_Zufrieden_Bier
replace ec_Zuf_Bier = e_G2_Zufrieden_Bier if ec_Zuf_Bier==-77

* Tobacco
clonevar ec_Zuf_Tabak = e_G1_Zufrieden_Tabak
replace ec_Zuf_Tabak = e_G2_Zufrieden_Tabak if ec_Zuf_Tabak==-77

*Clothing 
clonevar ec_Zuf_Kleidung = e_G1_Zufrieden_Kleidung
replace ec_Zuf_Kleidung = e_G2_Zufrieden_Kleidung if ec_Zuf_Kleidung==-77

*Chocolate 
clonevar ec_Zuf_Schoko = e_G1_Zufrieden_Schoko
replace ec_Zuf_Schoko = e_G2_Zufrieden_Schoko if ec_Zuf_Schoko==-77


*Medication 
clonevar ec_Zuf_Medi = e_G1_Zufrieden_Medi
replace ec_Zuf_Medi = e_G2_Zufrieden_Medi if ec_Zuf_Medi==-77

*Flowers 
clonevar ec_Zuf_Blumen = e_G1_Zufrieden_Blumen
replace ec_Zuf_Blumen = e_G2_Zufrieden_Blumen if ec_Zuf_Blumen==-77


*Pet 
clonevar ec_Zuf_Haustier = e_G1_Zufrieden_Haustier
replace ec_Zuf_Haustier = e_G2_Zufrieden_Haustier if ec_Zuf_Haustier==-77

*DVD
clonevar ec_Zuf_DVD = e_G1_Zufrieden_DVD
replace ec_Zuf_DVD = e_G2_Zufrieden_DVD if ec_Zuf_DVD==-77

*CD 
clonevar ec_Zuf_CD = e_G1_Zufrieden_CD
replace ec_Zuf_CD = e_G2_Zufrieden_CD if ec_Zuf_CD==-77

*tickets
clonevar ec_Zuf_Eintritt = e_G1_Zufrieden_Eintritt
replace ec_Zuf_Eintritt = e_G2_Zufrieden_Eintritt if ec_Zuf_Eintritt==-77

*Cleaning 
clonevar ec_Zuf_Putzzeug = e_G1_Zufrieden_Putzzeug
replace ec_Zuf_Putzzeug = e_G2_Zufrieden_Putzzeug if ec_Zuf_Putzzeug==-77


recode ec_Zuf_Kaffee - ec_Zuf_Putzzeug (0=6) // 0 into weiss nicht 
recode ec_Zuf_Kaffee - ec_Zuf_Putzzeug (-77=.) //not triggered into missing 
tab1 ec_Zuf_Kaffee - ec_Zuf_DVD, m 

global satis ec_Zuf_Kaffee - ec_Zuf_Putzzeug
// `satis'

** Create socio demogra from  Respondi reported ones when they are avaialable 
/*
clonevar female = v_4 
clonevar education = v_5
clonevar age = v_19
*/

 

* Expenses 

//merge the two groups into one 
rename e_G2_Ausg_Schoki e_G2_Ausg_Schoko
rename e_G2_Ausg_Schoki_na e_G2_Ausg_Schoko_na

 global words "Kaffee Bier Tabak Kleidung Schoko Medi Blumen Haustier DVD CD Eintritt Putzzeug"
 ** real numbers
        foreach y of global words {
                clonevar ea_Ausg_`y' = e_G1_Ausg_`y'
				replace ea_Ausg_`y' = e_G2_Ausg_`y' if ea_Ausg_`y'==-77
				recode ea_Ausg_`y' (-77=.)

        }

		tab ea_Ausg_Bier, m 
		
**don't know 

        foreach y of global words {
                clonevar ea_Ausg_na_`y' = e_G1_Ausg_`y'_na
				replace ea_Ausg_na_`y' = e_G2_Ausg_`y'_na if ea_Ausg_na_`y'==-77
				recode ea_Ausg_na_`y' (-77=.)

        }
		
		tab ea_Ausg_na_Bier, m 

** For whom have you purchased it - merge 2 groups into one **
 global words "Kaffee Bier Tabak Kleidung Schoki Medi Blumen Haustier DVD CD Eintritt Putzzeug" //slightly diff names for this var 


***mich	
	foreach y of global words {
		clonevar eb_whom_mich_`y' = e_G1_`y'_f_mich
		replace eb_whom_mich_`y' = e_G2_`y'_f_mich if eb_whom_mich_`y' ==-77
		recode eb_whom_mich_`y' (-77=.)
		
		}
		
		tab eb_whom_mich_Kaffee, m 

		
** Haushalt 
	foreach y of global words {
		clonevar eb_whom_HH_`y' = e_G1_`y'_f_HH
		replace eb_whom_HH_`y' = e_G2_`y'_f_HH if eb_whom_HH_`y' ==-77
		recode eb_whom_HH_`y' (-77=.)
				}
				tab eb_whom_HH_Kaffee, m 
		
** others
foreach y of global words {
clonevar eb_whom_andere_`y' = e_G1_`y'_f_andere
		replace eb_whom_andere_`y' = e_G2_`y'_f_andere if eb_whom_andere_`y' ==-77
		recode eb_whom_andere_`y' (-77=.) 
				}

tab eb_whom_andere_Kaffee, m 

**don't know 
foreach y of global words {
clonevar eb_whom_na_`y' = e_G1_`y'_f_na
		replace eb_whom_na_`y' = e_G2_`y'_f_na if eb_whom_na_`y' ==-77
		recode eb_whom_na_`y' (-77=.) 
				}
				
tab eb_whom_na_Kaffee, m

destring _all, replace


/*		
*-----------------(Build indicators for data quality)---------------------------*	

*** Average Filter Categories  - for whom have you purchased it 
// generate average value how  many filter cat where ticked 
egen cat_ticked_h = anycount(eb_whom_mich_Kaffee - eb_whom_andere_Putzzeug), values(1)
	
gen cat_ticked = cat_ticked_h / filterquest
tab cat_ticked, m  // average ticks in categorial follow up 

*** Average don't knows   - for whom have you purchased it 
// generate average don't knows  how many filter cat where ticked divided though times of filters triggered 
egen cat_na_h = anycount(eb_whom_na_Kaffee- eb_whom_na_Putzzeug), values(1)
gen cat_na = cat_na_h / filterquest
tab cat_na, m 
// average no of don't knows in car. var 


** Average don't knows across all subquests
*Prepare how much did it cost
egen Ausg_na = anycount(ea_Ausg_na_Kaffee - ea_Ausg_na_Putzzeug), values(1)
tab Ausg_na, m 

* prepare satisfaction with good 

egen satis_na = anycount(ec_Zuf_Kaffee -  ec_Zuf_Putzzeug), values(6)
tab satis_na, m 


gen  all_na = cat_na + Ausg_na + satis_na
tab all_na // counts all na's in follow ups 

* extreme answers for "how satified .." / times filter quest triggerd 

egen satis_extreme_h = anycount(ec_Zuf_Kaffee - ec_Zuf_Putzzeug), values(1 5)
gen satis_extreme= satis_extreme_h / filterquest

tab satis_extreme, m //average nu of extreme answer by filterquest 




* umrealistic answers for "how much did .." 
gen howmuch_unreal = 0

egen howmuch_unreal_h = anycount(ea_Ausg_Kaffee ea_Ausg_Putzzeug), values(0) // costs 0
tab howmuch_unreal_h, m 
replace howmuch_unreal = 1 if howmuch_unreal_h != 0  // unrealistic answer  if they paid 0 euro 

tab howmuch_unreal, m 

destring _all, replace


foreach var of varlist  ea_Ausg_Kaffee ea_Ausg_Bier ea_Ausg_Tabak ea_Ausg_Schoko ea_Ausg_Blumen ea_Ausg_Haustier ///
ea_Ausg_DVD ea_Ausg_CD ea_Ausg_Putzzeug {
recode  `var' (.=-77)
replace howmuch_unreal = 1 if `var' > 99   //replace value unreal if everyday good costs more than 100 euro 
recode  `var' (-77=.) 
}



tab howmuch_unreal, m
 

destring _all, replace

*/

** Data prep of socio demographics
/*tab c_0008, m 
replace c_0008 =. if c_0008==-66 */ // not available so far 


* Response Behavior 

// Response behavior completes by invitations 
gen rb_complete=. 
replace rb_complete = 100/  numinv2 * numcpl2
replace rb_complete = . if rb_complete > 100 // there are some people who have more completions than invites  set as missing

tab rb_complete, m 

// Response behavior interview  started  by invitations 
gen rb_start=. 
replace rb_start = 100/  numinv2 * numstr2


replace rb_start = . if rb_start > 100 // Attention due to ?cookie issues? have more than 40% more completes than starts set those as missing

tab rb_start, m  

// Time of panel participation
** we set those with unreasonable dates to .  

** Mean and median Response Time 

replace diff2=. if diff2==.a | diff2==.b // set unreasonable values as missing
tab diff2, m 

ttest diff2, by(device)

mean duration if dispcode==31

ttest duration if dispcode==31, by(mobile)  // duration by device acccpring to chris 

ttest duration if dispcode==31, by(interleafed) // duration by format 

// median 

tabstat duration if dispcode==31, s(median)

tabstat duration if dispcode==31, s(median) by(mobile)


tabstat duration if dispcode==31, s(median) by(interleafed)


// Für PC knapp 31 Für smartphone knapp 37 Minuten



// 33 minutes and 24 seconds
		
* --------------- ( Check randomization for mode and  format  ) --------------- *



foreach var of varlist  Ausbildungsabschluss Einkommen_netto Einwohnerzahl diff2 ///
 Geschlecht Alter Bundesland Bildung employment_status  size_residence rb_start rb_complete{

reg mobile `var' //mobile
estimates store `var'
qui: coefplot `var', drop(_cons) xline(0)

}


coefplot Einkommen_netto Einwohnerzahl diff2 ///
 Geschlecht Alter Bundesland Bildung employment_status  size_residence rb_start rb_complete, ///
 drop(_cons) xline(0) graphregion(color(white)) bgcolor(white)  mcolor(black)  ///
 coeflabels(Einkommen_netto = "Net income" Geschlecht =  "Sex"  Bildung = "Education" Einwohnerzahl = "Population Size" ///
 size_residence = "Housing situation"  rb_complete = "Survey completion date" Alter = "Age"  employment_status = "Employment status" ///
 Bundesland = "Federal State" diff2 = "Duration of the survey" rb_start = "Survey invitation date") leg(off) name(device_before)


 // Format 
 
foreach var of varlist  Ausbildungsabschluss Einkommen_netto Einwohnerzahl diff2 ///
 Geschlecht Alter Bundesland Bildung employment_status  size_residence rb_start rb_complete{

reg  interleafed `var'   //format
estimates store `var'1
qui: coefplot `var'1, drop(_cons) xline(0)
}




coefplot Einkommen_netto1 Einwohnerzahl1 diff21 ///
 Geschlecht1 Alter1 Bundesland1 Bildung1 employment_status1  size_residence1 rb_start1 rb_complete1, ///
 drop(_cons) xline(0) graphregion(color(white)) bgcolor(white)  mcolor(black)  ///
 coeflabels(Einkommen_netto = "Net income" Geschlecht =  "Sex"  Bildung = "Education" Einwohnerzahl = "Population Size" ///
 size_residence = "Housing situation"  rb_complete = "Survey completion date" Alter = "Age"  employment_status = "Employment status" ///
 Bundesland = "Federal State" diff2 = "Duration of the survey" rb_start = "Survey invitation date") leg(off) name(format_before)



 
 

// UPDATE randomization did not work for income, city size and education ! 

// 4- sex,   , 5- education, 10 - federal state, 19 - age

* --------------- ( Weighting for unbalanced vars  ) --------------- *

* Weights only from Respondent data 
ebalance mobile Ausbildungsabschluss Einkommen_netto Einwohnerzahl ///
 Geschlecht Alter     size_residence employment_status Bundesland Bildung ///
 rb_start rb_complete diff2  , targets(1) gen(weight1) maxiter(150) 



* Weights for respondent and nonresp. data 
// create dataset which includes resp and nonresp. and take the nonresp-balancing weights for the resp.


**** Check randomization after weighting *****

*Device after eightung 

foreach var of varlist  Ausbildungsabschluss Einkommen_netto Einwohnerzahl diff2 ///
 Geschlecht Alter Bundesland Bildung employment_status  size_residence rb_start rb_complete{

reg mobile `var'  [pw=weight1] //mobile
estimates store `var'2
qui: coefplot `var'2, drop(_cons) xline(0)

}



coefplot Einkommen_netto2 Einwohnerzahl2 diff22 ///
 Geschlecht2 Alter2 Bundesland2 Bildung2 employment_status2  size_residence2 rb_start2 rb_complete2, ///
 drop(_cons) xline(0) graphregion(color(white)) bgcolor(white)  mcolor(black)  ///
 coeflabels(Einkommen_netto = "Net income" Geschlecht =  "Sex"  Bildung = "Education" Einwohnerzahl = "Population Size" ///
 size_residence = "Housing situation"  rb_complete = "Survey completion date" Alter = "Age"  employment_status = "Employment status" ///
 Bundesland = "Federal State" diff2 = "Duration of the survey" rb_start = "Survey invitation date") leg(off) name(device_after)


 gr combine device_before device_after , title("Device before and after weigthing") note("left: Device before weighting, right: Device after weighting")
gr save device_weight, replace 

 
 
 // Format after wieghtung 
 
foreach var of varlist  Ausbildungsabschluss Einkommen_netto Einwohnerzahl diff2 ///
 Geschlecht Alter Bundesland Bildung employment_status  size_residence rb_start rb_complete{

reg  interleafed `var' [pw=weight1]   //format
estimates store `var'3
qui: coefplot `var'3, drop(_cons) xline(0)
}




coefplot Einkommen_netto3 Einwohnerzahl3 diff23 ///
 Geschlecht3 Alter3 Bundesland3 Bildung3 employment_status3  size_residence3 rb_start3 rb_complete3, ///
 drop(_cons) xline(0) graphregion(color(white)) bgcolor(white)  mcolor(black)  ///
 coeflabels(Einkommen_netto = "Net income" Geschlecht =  "Sex"  Bildung = "Education" Einwohnerzahl = "Population Size" ///
 size_residence = "Housing situation"  rb_complete = "Survey completion date" Alter = "Age"  employment_status = "Employment status" ///
 Bundesland = "Federal State" diff2 = "Duration of the survey" rb_start = "Survey invitation date") leg(off) name(format_after)



 gr combine format_before format_after, title("Format before and after weigthing") note("left: Format before weighting, right: Format after weighting")
 
gr save format_weight, replace 


 






* Randomizaton did not work for  education and device as well as age  and device , sex and device 







 

* --------------- ( Wide format Data Analysis for Misreporting in Mobile Surveys Paper ) --------------- *


poisson filterquest interleafed##mobile [pw=weight1], vce(cluster lfdn)

poisson filterquest1 interleafed##mobile [pw=weight1], vce(cluster lfdn) // without first filter quest 




foreach var of varlist e_Kaffee e_Schokolade e_KleidungSchuhe e_Tabak e_BierWein e_Medikamente e_Blumen e_haustier e_DVD e_CD e_Putzzeug  {
logit `var' interleafed##mobile  // no format effect sig. 

}

* Create MEANS table by format and device 

tab  interleafed mobile , cell





//test _subpop_1 = _subpop_2
//test _subpop_3 = _subpop_4
// test _subpop_3 - _subpop_4 =_subpop_1 - _subpop_2

**** TT TEST Table N's
mean filterquest 
mean filterquest [pw=weight1], over(interleafed)

ttest filterquest , by(interleafed) 
 
mean filterquest [pw=weight1], over(mobile)
ttest filterquest , by(mobile)  
tab interleafed if mobile ==0
tab interleafed if mobile ==1
tab mobile if interleafed ==0
tab mobile if interleafed ==1

//TTest for grouped format 
ttest filterquest if interleafed==0, by (mobile) 
ttest filterquest if interleafed==1, by (mobile) 

ttest filterquest if mobile==0, by (interleafed) 
ttest filterquest if mobile==1, by (interleafed) 


** check it in a regression 
poisson filterquest interleafed##mobile [pw=weight1], vce(cluster lfdn)

est sto reg_main 

* Set quantiles

xtile quant = filterquest, nq(4)
tab quant, m 

* Check if respondets with more or less filter questions answer different 
poisson filterquest interleafed##mobile if quant==1 [pw=weight1], vce(cluster lfdn)

poisson filterquest interleafed##mobile if quant==4 [pw=weight1], vce(cluster lfdn)

poisson filterquest interleafed##mobile##quant


* * --------------- ( Reshape data from wide to long  ) --------------- *


*reshape long e_Kaffee -e_Putzzeug, i(lfdn) j(id)
 clonevar good1 = e_Kaffee 
 clonevar good2 = e_BierWein 
 clonevar good3 = e_Tabak 
 clonevar good4 = e_KleidungSchuhe 
 clonevar good5 = e_Schokolade
 clonevar good6 = e_Medikamente 
 clonevar good7 = e_Blumen 
 clonevar good8 = e_haustier 
 clonevar good9 = e_DVD 
 clonevar good10 = e_CD 
 clonevar good11 = e_Eintrittskarte
 clonevar good12 = e_Putzzeug 
 
****************************** PREPARE FORMAT SWIRCH *************************
 
 * Prepare format switch: create long format for expenses for good 

 
* For expenses  creates a new variable ausgood_  that counts from 1 to 11 each number represents an item  
* ausgood_ will in the long format contain the amount of money spend by good 

local a=1 
 
 
foreach var of varlist ea_Ausg_Kaffee ea_Ausg_Bier ea_Ausg_Tabak ea_Ausg_Kleidung ea_Ausg_Schoko ///
ea_Ausg_Medi ea_Ausg_Blumen ea_Ausg_Haustier ea_Ausg_DVD ea_Ausg_CD ea_Ausg_Eintritt ea_Ausg_Putzzeug {


clonevar ausgood_`a' = `var'
 
local a =`a'+1
}


tab ausgood_10
 
 
// ceates an var  ausgoodna_ if the NA category was ticked 
 
 
local a=1  
foreach var of varlist ea_Ausg_na_Kaffee ea_Ausg_na_Bier ea_Ausg_na_Tabak ea_Ausg_na_Kleidung ea_Ausg_na_Schoko ea_Ausg_na_Medi ea_Ausg_na_Blumen ea_Ausg_na_Haustier ///
ea_Ausg_na_DVD ea_Ausg_na_CD ea_Ausg_na_Eintritt ea_Ausg_na_Putzzeug {


clonevar ausgoodna_`a' = `var'
 
local a =`a'+1
}
tab ausgoodna_1


 

 **
 
//  prepare format switch: create long format for satisfaction with good 
 
 **
 local a=1 
  foreach var of varlist  ec_Zuf_Kaffee ec_Zuf_Bier ec_Zuf_Tabak ec_Zuf_Kleidung ec_Zuf_Schoko ec_Zuf_Medi ec_Zuf_Blumen ec_Zuf_Haustier ec_Zuf_DVD ec_Zuf_CD ec_Zuf_Eintritt ec_Zuf_Putzzeug  {


clonevar satisgood_`a' = `var'
 
local a =`a'+1
}
 
tab satisgood_10 
 
**** prepare format switch: All for whom have you purchased in one Var 
 
 
 
 // Für Mich
local a=1 
foreach var of varlist eb_whom_mich_Kaffee eb_whom_mich_Bier eb_whom_mich_Tabak eb_whom_mich_Kleidung eb_whom_mich_Schoki eb_whom_mich_Medi eb_whom_mich_Blumen eb_whom_mich_Haustier eb_whom_mich_DVD eb_whom_mich_CD eb_whom_mich_Eintritt eb_whom_mich_Putzzeug {
 
 clonevar whomgood_mich_`a' = `var'

local a =`a'+1
}
 
 // Für Haushalt
 local a=1 
foreach var of varlist eb_whom_HH_Kaffee eb_whom_HH_Bier eb_whom_HH_Tabak eb_whom_HH_Kleidung ///
 eb_whom_HH_Schoki eb_whom_HH_Medi eb_whom_HH_Blumen eb_whom_HH_Haustier eb_whom_HH_DVD eb_whom_HH_CD eb_whom_HH_Eintritt eb_whom_HH_Putzzeug {
 
 clonevar whomgood_HH_`a' = `var'

local a =`a'+1
}

// Für andere
 local a=1 
foreach var of varlist eb_whom_andere_Kaffee eb_whom_andere_Bier eb_whom_andere_Tabak eb_whom_andere_Kleidung eb_whom_andere_Schoki eb_whom_andere_Medi eb_whom_andere_Blumen eb_whom_andere_Haustier eb_whom_andere_DVD eb_whom_andere_CD eb_whom_andere_Eintritt eb_whom_andere_Putzzeug {
 
 clonevar whomgood_andere_`a' = `var'

local a =`a'+1
}

tab whomgood_andere_4, m

// Nicht angegeben
 local a=1 
foreach var of varlist eb_whom_na_Kaffee eb_whom_na_Bier eb_whom_na_Tabak eb_whom_na_Kleidung ///
eb_whom_na_Schoki eb_whom_na_Medi eb_whom_na_Blumen ///
 eb_whom_na_Haustier eb_whom_na_DVD eb_whom_na_CD eb_whom_na_Eintritt eb_whom_na_Putzzeug {
 
 clonevar whomgood_na_`a' = `var'

local a =`a'+1
}

tab whomgood_na_9, m 
tab ausgood_10
 
 
***** Reshaping from wide to long  
 
reshape long good ausgood_ ausgoodna_ satisgood_ whomgood_mich_ whomgood_HH_ whomgood_andere_ whomgood_na_ , i(lfdn) j(order) 

 
 ******************* Unrealistic price value *********************************

 
 gen is_unreal = 0

// or if all items besides alcohol or colthign are larger than 99
replace is_unreal =1 if ausgood_ > 99 
tab is_unreal 

// change it back if clothes or wine is more than 100
replace is_unreal = 0 if e_BierWein==1 |  e_KleidungSchuhe==1 // because wine and cloth cost more than 99
tab is_unreal 

// If resp. indicated 0
replace is_unreal =1 if ausgood_ == 0 // more relaistic smaller than 1? 


tab is_unreal, m 


* Try when everything  below 1 is unreal 


** Generate Heaping  Var  (Heaping means in our definition dividable through 10) 
 gen is_heaping = 0

// divideable through   10 
replace is_heaping =1 if ausgood_ == 0  | ausgood_==10 | ausgood_ == 20  | ausgood_==30 | ausgood_ == 40  | ausgood_==50 | ausgood_ == 60  | ausgood_==70 | ausgood_ == 80  | ausgood_==90 | ausgood_ == 100  | ausgood_==110 | ausgood_ == 120  | ausgood_==130 
replace is_heaping=. if ausgood_ ==.

tab is_heaping,m 


************************************ Indicator: Don't know  *******************************
**** Indicator is 1 if na. is ticked or there is item nonresponse 

gen is_na = 0

replace is_na = 1 if ausgoodna_ ==1 // is 1 when resp ticked in the how much question na 
replace is_na = 1 if whomgood_na_ ==1  // is 1 when resp. tcikes in the for whom question na
replace is_na = 1 if satisgood_ ==6 // is 1 when they ticked the don't know answer in teh satisfaction quest 


replace is_na = . if ausgood_ ==. // is 1 when resp ticked in the how much question na 
replace is_na = . if whomgood_mich_ ==.  // is 1 when resp. tcikes in the for whom question na
replace is_na = . if satisgood_ ==. 

tab is_na, m 





**************************** Indicator:  Category ticked***************************

* This variable indicates if smbd ticked everything in for whom have you pur item 

gen all_ticks =0

replace all_ticks= 1 if whomgood_mich_==1 & whomgood_HH_==1 & whomgood_andere_ ==1 & whomgood_na_ ==1 //If somebody 

tab all_ticks, m  //

// variable shows if smbd . ticked everything


**************************** Indicator:  No Category NOT ticked***************************

* This variable indicates the number of categories not ticked  
// counts if one of the three for whom have you purchased item is 0 , 0 means  that they did not tick it  

egen nu_nticks = anycount(whomgood_mich_ whomgood_HH_ whomgood_andere_ whomgood_na_) , values(0) // codes everything which is not triggered  
replace nu_nticks =. if  whomgood_mich_ ==. // set the  case as missing if the filter quest was not triggered



tab nu_nticks, m 
mean nu_nticks

*transform it in percentages 100% =4

gen per_nticked = .
replace per_nticked= 100 if nu_nticks==4 
replace per_nticked= 75 if nu_nticks==3 
replace per_nticked= 50 if nu_nticks==2 
replace per_nticked= 25 if nu_nticks==1 

tab per_nticked, m 

mean per_nticked
descr per_nticked
 

// variable shows how many categories where not ticked 

**************************** Binary Dummy one vs. 2 or more ticked ***************************
// Attention needs to be coded in the not ticked direction which means:  2, 3 or 4 not ticked (1 ticked) vs. 0 or 1 not ticked 


gen notticked_binary=. 

replace notticked_binary= 0 if nu_nticks ==1 | nu_nticks ==2 | nu_nticks ==0
replace notticked_binary= 1 if nu_nticks ==3 | nu_nticks ==4


tab  notticked_binary, m 




************************** Middle Category ********************************

gen middle_cat=0
replace middle_cat =1 if satisgood_ == 3
replace middle_cat= . if satisgood_ == . 
tab middle_cat, m 

  // variable shows if middle cat is ticked  
  
  
 

 * --------------- ( Long format Data Analysis for Misreporting in Mobile Surveys Paper ) --------------- *
 
*****  A Overall regression model if main filter is sig.  all vars 
 
 reg good interleafed##mobile  [pw=weight1], vce(cluster lfdn)
 eststo ols1
 
 estout ols1 ,  label cells(b(fmt(%7.4g)star) se(fmt(%7.4g))) stats(N r2)
 
 * FINAL Analysis for plot * 
 mean good [pw=weight1],   over(interleafed mobile)   vce(cluster lfdn) 
test _subpop_1 = _subpop_2
test _subpop_3 = _subpop_4
test _subpop_3 - _subpop_4 =_subpop_1 - _subpop_2
 
 
 reg good interleafed##mobile [pw=weight1] 
 svyset lfdn [pw=weight1]
 svy: reg good interl##mobile
 
 
 
 //gen wtf = e(sample)

//tab wtf
//sum weight1 wtf



**** B Overall regression model if main filter is sig.  without first var (coffee) 
 
 reg good interleafed
  eststo ols1
 reg good mobile
  eststo ols2
 
 reg good interleafed##mobile if order!=1 [pw=weight1], vce(cluster lfdn) 
 eststo ols3
 
 estout ols1 ,  label cells(b(fmt(%7.4g)star) se(fmt(%7.4g))) stats(N r2)

 
 
coefplot ols3, drop(_cons) xline(0) graphregion(color(white)) bgcolor(white)  mcolor(black) coeflabels(1.interleafed = "Interleafed Format" 1.mobile =  "Smartphone"  1.interleafed#1.mobile= "Interleafed*Smartphone") leg(off) name(format_before,replace) 
 
 
* FINAL Analysis for plot * 
 mean good [pw=weight1],   over(interleafed mobile)   vce(cluster lfdn) 
test _subpop_1 = _subpop_2
test _subpop_3 = _subpop_4
test _subpop_3 - _subpop_4 =_subpop_1 - _subpop_2

test _subpop_2 = _subpop_4
test _subpop_1 = _subpop_3
 
**Reression tables
 
 ********
 reg good interleafed##mobile [pw=weight1] 
 svyset lfdn [pw=weight1]
 svy: reg good interl##mobile
 
 
 
gen wtf = e(sample)

tab wtf
sum weight1 wtf

 **FOR TABLE fin 
 
*****  C Differences by education -> no diffrences 
tab highedu,m 

 reg good  interleafed##mobile##highedu,  vce(cluster lfdn)
  mean good [pw=weight1],   over(interleafed mobile highedu)   vce(cluster lfdn) 
test _subpop_1 = _subpop_2 //n.s. 
test _subpop_7 = _subpop_8 // interleafed mobile and high edu shows 
test _subpop_1 - _subpop_7 =_subpop_2 - _subpop_8 // diff. between high and low edu
 
 reg good interleafed##mobile interleafed##highedu 

 **
 
*include age and edu
//reg good  interleafed##mobile  c.v_19##c.v_19  i.v_5,  vce(cluster lfdn) // asap when respondi data arrive


 * --------------- ( follow up -question analysis for Misreporting in Mobile Surveys Paper ) --------------- *

 
 ** Unrealistic Price values 
 logit is_unreal interleafed##mobile  [pw=weight1], vce(cluster lfdn)
 logit is_unreal interleafed##mobile if order!=1 [pw=weight1], vce(cluster lfdn) // without first filter quest 

 
  ** Heaping Price values (divideable though 10) 
 logit is_heaping interleafed##mobile  [pw=weight1], vce(cluster lfdn)
 logit is_heaping interleafed##mobile if order!=1 [pw=weight1], vce(cluster lfdn) // without first filter quest 

 
 
 ** Ticked don't know or item nonresponse 
 logit is_na interleafed##mobile  [pw=weight1], vce(cluster lfdn)
 logit is_na interleafed##mobile if order!=1 [pw=weight1], vce(cluster lfdn) // without first filter quest 


 
 ** Ticked all categories in for whom have you purchased
 *logit all_ticks interleafed##mobile  [pw=weight1], vce(cluster lfdn)
 *logit all_ticks interleafed##mobile if order!=1 [pw=weight1], vce(cluster lfdn) // without first filter quest 
 
 
 *Number of Categories not ticked 
 reg per_nticked interleafed##mobile  [pw=weight1], vce(cluster lfdn)
 reg per_nticked interleafed##mobile if order!=1  [pw=weight1], vce(cluster lfdn)
 
 
 * Bot ticked binary - 0  or 1 vs. 2, 3, and 4 
 reg notticked_binary  interleafed##mobile  [pw=weight1], vce(cluster lfdn)
 reg notticked_binary interleafed##mobile if order!=1  [pw=weight1], vce(cluster lfdn)
 
 
 **Middle category in how satisfied 
 logit middle_cat interleafed##mobile  [pw=weight1], vce(cluster lfdn)
 logit middle_cat interleafed##mobile if order!=1  [pw=weight1], vce(cluster lfdn)
 


** Final Analyses for Graphs  


** summary stats for ondicators 


 graph box   is_na middle_cat  , medtype(line)
 
summarize is_heaping is_na middle_cat per_nticked, detail



/*
* Extreme price values 
// is_unreal =1 indicates that the price value is unrealistic 
logit  is_unreal interleafed##mobile [pw=weight1], vce(cluster lfdn)
mean is_unreal [pw=weight1],   over(interleafed mobile)   vce(cluster lfdn) 

test _subpop_1 = _subpop_2
test _subpop_3 = _subpop_4
test _subpop_3 - _subpop_4 =_subpop_1 - _subpop_2

// Without weight 
logit  is_unreal interleafed##mobile , vce(cluster lfdn)
*/

* Heaping price values (divideable through 10) 
// is_heaping indicates if respondent did heaping 
logit  is_heaping interleafed [pw=weight1], vce(cluster lfdn)
logit  is_heaping mobile [pw=weight1], vce(cluster lfdn)

logit  is_heaping interleafed [pw=weight1], vce(cluster lfdn)
eststo heap1

logit  is_heaping mobile [pw=weight1], vce(cluster lfdn)
eststo heap2

logit  is_heaping interleafed##mobile [pw=weight1], vce(cluster lfdn)
eststo heap3
 
 estout heap3 ,  label cells(b(fmt(%7.4g)star) se(fmt(%7.4g))) stats(N r2)



mean is_heaping [pw=weight1],   over(interleafed mobile)   vce(cluster lfdn) 

test _subpop_1 = _subpop_2
test _subpop_3 = _subpop_4
test _subpop_3 - _subpop_4 =_subpop_1 - _subpop_2

test _subpop_2 = _subpop_4
test _subpop_1 = _subpop_3



* Is Don't knows 
// indicates if respondent gave us a don't know or item- nr 
logit is_na interleafed [pw=weight1], vce(cluster lfdn) 
logit is_na mobile [pw=weight1], vce(cluster lfdn) 


logit is_na interleafed  [pw=weight1], vce(cluster lfdn) 


eststo isna1
 


logit is_na mobile  [pw=weight1], vce(cluster lfdn) 


eststo isna2
 


logit is_na mobile##interleafed  [pw=weight1], vce(cluster lfdn) 


eststo isna3
 
 estout isna3 ,  label cells(b(fmt(%7.4g)star) se(fmt(%7.4g))) stats(N r2)



mean is_na[pw=weight1],   over(interleafed mobile)   vce(cluster lfdn) 
test _subpop_1 = _subpop_2
test _subpop_3 = _subpop_4
test _subpop_3 - _subpop_4 =_subpop_1 - _subpop_2

test _subpop_2 = _subpop_4
test _subpop_1 = _subpop_3


/*
* All categories ticked 
// indicates if all catgeories were ticked in the *for whom* questions
logit  all_ticks interleafed##mobile [pw=weight1], vce(cluster lfdn)

mean all_ticks[pw=weight1],   over(interleafed mobile)   vce(cluster lfdn) 
test _subpop_1 = _subpop_2
test _subpop_3 = _subpop_4
test _subpop_3 - _subpop_4 =_subpop_1 - _subpop_2
*/

* Percent of categories not ticked
// counts how many categories were not ticked  in the for whom question
 reg per_nticked interleafed  [pw=weight1], vce(cluster lfdn)
  reg per_nticked mobile  [pw=weight1], vce(cluster lfdn)

    
    reg per_nticked interleafed  [pw=weight1], vce(cluster lfdn)

  
  eststo nticks1
 
	
    reg per_nticked mobile  [pw=weight1], vce(cluster lfdn)

  
  eststo nticks2
 
	
	reg per_nticked interleafed##mobile  [pw=weight1], vce(cluster lfdn)

  
  eststo nticks3
 
 estout nticks3 ,  label cells(b(fmt(%7.4g)star) se(fmt(%7.4g))) stats(N r2)

 
mean per_nticked[pw=weight1],   over(interleafed mobile)   vce(cluster lfdn) 
test _subpop_1 = _subpop_2
test _subpop_3 = _subpop_4
test _subpop_3 - _subpop_4 =_subpop_1 - _subpop_2


test _subpop_2 = _subpop_4
test _subpop_1 = _subpop_3


* Middle Category 
// indicates if middle category is ticked 
 logit middle_cat interleafed  [pw=weight1], vce(cluster lfdn)
  logit middle_cat mobile  [pw=weight1], vce(cluster lfdn)
  
    
 logit middle_cat interleafed  [pw=weight1], vce(cluster lfdn)

  eststo mid1
 
    
 logit middle_cat mobile  [pw=weight1], vce(cluster lfdn)

  eststo mid2
 
  
  
 logit middle_cat interleafed##mobile  [pw=weight1], vce(cluster lfdn)

  eststo mid3
 
 estout mid3 ,  label cells(b(fmt(%7.4g)star) se(fmt(%7.4g))) stats(N r2)


  

mean middle_cat[pw=weight1],   over(interleafed mobile)   vce(cluster lfdn) 
test _subpop_1 = _subpop_2
test _subpop_3 = _subpop_4
test _subpop_3 - _subpop_4 =_subpop_1 - _subpop_2


test _subpop_2 = _subpop_4
test _subpop_1 = _subpop_3


** estout all 
estout  ols1 ols2 ols3 heap1 heap2 heap3   , label cells(b(fmt(%7.4g)star) se(fmt(%7.4g))) stats(N r2)

estout isna1 isna2 isna3 nticks1 nticks2 nticks3   , label cells(b(fmt(%7.4g)star) se(fmt(%7.4g))) stats(N r2)

estout mid1 mid2 mid3,   label cells(b(fmt(%7.4g)star) se(fmt(%7.4g))) stats(N r2)

* only format
estout mid1 heap1 isna1 nticks1,   label cells(b(fmt(%7.4g)star) se(fmt(%7.4g))) stats(N r2)

*only device 
estout mid2 heap2 isna2 nticks2,   label cells(b(fmt(%7.4g)star) se(fmt(%7.4g))) stats(N r2)


*Plots
coefplot ols3, drop(_cons) xline(0) graphregion(color(white)) bgcolor(white)  mcolor(black) coeflabels(1.interleafed = "Interleafed Format" 1.mobile =  "Smartphone"  1.interleafed#1.mobile= "Interleafed*Smartphone") leg(off) name(format_before,replace) xtitle(ols3)
coefplot heap3, drop(_cons) xline(0) graphregion(color(white)) bgcolor(white)  mcolor(black) coeflabels(1.interleafed = "Interleafed Format" 1.mobile =  "Smartphone"  1.interleafed#1.mobile= "Interleafed*Smartphone") leg(off) name(format_before,replace) xtitle(heap3)
coefplot nticks3, drop(_cons) xline(0) graphregion(color(white)) bgcolor(white)  mcolor(black) coeflabels(1.interleafed = "Interleafed Format" 1.mobile =  "Smartphone"  1.interleafed#1.mobile= "Interleafed*Smartphone") leg(off) name(format_before,replace) xtitle(nticks3)
coefplot mid3, drop(_cons) xline(0) graphregion(color(white)) bgcolor(white)  mcolor(black) coeflabels(1.interleafed = "Interleafed Format" 1.mobile =  "Smartphone"  1.interleafed#1.mobile= "Interleafed*Smartphone") leg(off) name(format_before,replace) xtitle(mid3)
coefplot isna3, drop(_cons) xline(0) graphregion(color(white)) bgcolor(white)  mcolor(black) coeflabels(1.interleafed = "Interleafed Format" 1.mobile =  "Smartphone"  1.interleafed#1.mobile= "Interleafed*Smartphone") leg(off) name(format_before,replace) xtitle(isna3)

coefplot ols3 || heap3 || nticks3 || mid3 || isna3, drop(_cons) xline(0) graphregion(color(white)) bgcolor(white)  mcolor(black) coeflabels(1.interleafed = "Interleafed Format" 1.mobile =  "Smartphone"  1.interleafed#1.mobile= "Interleafed*Smartphone") leg(off) name(format_before,replace) byopts(xrescale)


log close 
