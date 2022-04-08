(define (problem cashpoint0) (:domain cashpoint)
(:objects
	location0  - shop
	bank0 bank1  - bank
	changeOffice0  - changeOffice
	item0 item1  - item
	currency0 currency1  - currency
)

(:init
	(at location0)(available)
	(canbuy location0 item0)
	(canbuy location0 item1)
	(= (currency_goal currency0) 248)
	(= (currency_goal currency1) 242)
	(= (price item0) 4)
	(= (price item1) 84)
	(= (balance currency0) 451)
	(= (balance currency1) 684)
	(= (exchangeRate currency0 currency1) 1.87402)
	(= (exchangeRate currency1 currency0) 0.533612)
	(= (inpocket currency0) 145)
	(= (inpocket currency1) 56)
	(= (points currency0) 15)
	(= (points currency1) 1)
	(= (bank-reserve bank0 currency0) 8538)
	(= (bank-reserve bank0 currency1) 7578)
	(= (bank-reserve bank1 currency0) 6636)
	(= (bank-reserve bank1 currency1) 3093)
	(canwithdraw bank0)
	(canwithdraw bank1)
	(currencyOf item0 currency0)
	(currencyOf item1 currency0)
	(canexchange changeOffice0)
	(different-currencies currency0 currency1)
	(different-currencies currency1 currency0)
	(link location0 bank0 )
	(link location0 bank1 )
	(link location0 changeOffice0 )
	(link bank0 location0 )
	(link bank0 bank1 )
	(link bank0 changeOffice0 )
	(link bank1 location0 )
	(link bank1 bank0 )
	(link bank1 changeOffice0 )
	(link changeOffice0 location0 )
	(link changeOffice0 bank0 )
	(link changeOffice0 bank1 ))

(:goal	(and

	(bought item0)
	(bought item1)
	(have_enough currency1)
	(have_enough currency0)
		)
	)
)