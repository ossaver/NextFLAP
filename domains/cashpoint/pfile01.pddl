(define (problem cashpoint0) (:domain cashpoint)
(:objects
	location0  - shop
	bank0  - bank
	changeOffice0  - changeOffice
	item0  - item
	currency0  - currency
)

(:init
	(at location0)(available)
	(canbuy location0 item0)
	(= (currency_goal currency0) 249)
	(= (price item0) 8)
	(= (balance currency0) 250)
	(= (inpocket currency0) 95)
	(= (points currency0) 15)
	(= (bank-reserve bank0 currency0) 2021)
	(canwithdraw bank0)
	(currencyOf item0 currency0)
	(canexchange changeOffice0)
	(link location0 bank0 )
	(link location0 changeOffice0 )
	(link bank0 location0 )
	(link bank0 changeOffice0 )
	(link changeOffice0 location0 )
	(link changeOffice0 bank0 ))

(:goal	(and

	(bought item0)
	(have_enough currency0)
		)
	)
)