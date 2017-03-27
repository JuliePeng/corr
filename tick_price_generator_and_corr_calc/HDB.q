HDB_SPLAYED:"C:/Users/pzlap/Documents/TICK_HDB_SPLAYED/"
;
sym:get hsym `$HDB_SPLAYED, "/sym";
data:get hsym `$raze HDB_SPLAYED,"lastprice";

calc_corr:{[t1;t2;window;leading]
	0N!(t1;t2;window;leading);
	prices_t1:select price by window xbar date from data where ticker =t1;
	prices_t2:select price by window xbar date-leading from data where ticker =t2;
	prices:prices_t1 lj 1!`date`prices2 xcol 0!prices_t2;
	prices_count: select c1: count raze price, c2:count raze prices2 by date from prices;
	prices:delete c1,c2 from (select from prices_count where c1=c2) lj prices;
	corr_windows:select corr:(raze price) cor (raze prices2) by date from prices;
	:(t1;t2;window;leading;exec avg corr from corr_windows)
	}


leadings:0 1 5 10 30;
windows: 30 60 90 120 300;
CORR_TBL_TO_SAVE:();
SYM_UNIVERSE:100#exec distinct sym from data;

calc_corr_for_one_tick:{[x]
	tickers2:(1+(first where SYM_UNIVERSE=x)) _ SYM_UNIVERSE;
	results: calc_corr ./: raze (x ,/: tickers2) ,/:\: raze windows ,/:\: leadings;
	corr_tbl:([]t1: results[;0]; t2: results[;1];window: results[;2]; leading: results[;3]; corr:results[;4]);
	/existing_tbl:@[{get hsym `$raze HDB_SPLAYED,x};"corr";()];
	/to_save:existing_tbl, corr_tbl;
	table_name:ssr[string x;".";""];
	(hsym `$"results/",table_name,".csv") 0:  ";" 0: corr_tbl;
	/(`$table_name) set corr_tbl;
	/(hsym `$raze HDB_SPLAYED,(string x), "/") set .Q.en[hsym `$HDB_SPLAYED;corr_tbl]
	}





files:("results/" ,/: {ssr[x;".";""]} each string SYM_UNIVERSE) ,\: ".csv";

read_results:{[file]
	content:1_flip ("SSIIF";";") 0: hsym `$file;
	:([t1: content[;0];t2: content[;1];window:content[;2];leading:content[;3]] corr: content[;4]);
	}


lastprice:2!get hsym `$raze HDB_SPLAYED,"lastprice";
corr:4!get hsym `$raze HDB_SPLAYED,"corr"