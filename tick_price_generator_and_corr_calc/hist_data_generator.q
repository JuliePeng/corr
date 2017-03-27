HDB:"C:/Users/pzlap/Documents/TICK_HDB"
/
;
HDB_SPLAYED:"C:/Users/pzlap/Documents/TICK_HDB_SPLAYED/"

;
TICK_NAME_FILE:"C:\\Users\\pzlap\\Documents\\tick\\ticker_name.csv"

;
tick_names: `$read0 hsym `$

TICK_NAME_FILE;
tick_names:`${-1_x} each string tick_names;

price_generator:{[num_of_days;t;base_p;randomness]
			([date:.z.d- til num_of_days; ticker:num_of_days#t ] price: base_p+ {[x;y]rand(x)}[randomness;] each til num_of_days) }






save_data_on_date:{[day;data] (hsym `$raze HDB,"/",string day, "/tick/") set data}

;

save_data:{[data]
		dates: exec date from select distinct date from data;
			
			
		data_to_save_by_date: {[day;data]select ticker, price from data where date=day}[;data] each  dates;

			
	        save_data_on_date ./: flip(dates;data_to_save_by_date)

	}

;


main:{
	
data:raze price_generator[4000;;;] ./: flip (tick_names; {rand(3000)} each til count tick_names; {rand(20.0)} each til count tick_names);
	(hsym `$HDB_SPLAYED) set .Q.en[hsym `$HDB_SPLAYED; 0!data];
	}






