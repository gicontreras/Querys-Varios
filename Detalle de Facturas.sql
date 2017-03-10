SELECT SHP.STORE_ID CODFARMA,
	    ST.NM_ORGN FARMACIA,
	    SHP.ASN_ID,
	    SHP.INVOICE_ID FACTURA,
	    SHP.FROM_LOCATION_ID CODPROV,
	    S.NM_SPR PROVEEDOR,
	    SHP.CREATE_DATE CREADO,
	    SHP.COMPLETE_DATE RECEPCI�N,
	    SHP.INVOICE_DATE,
	    DECODE (SHP.STATUS,	0,	'Nuevo',	1,	'En Progreso',	2,	'Recibido',	4,	'Cancelado',	'Revisar ORSIM'	) ESTATUS,
	    DECODE (SHP.FROM_LOCATION_TYPE, 'SP', 'Proveedor', 'WH', 'Almacen', 'Revisar ORSIM') TIPO_RECEPCION,
	    SI.ITEM_ID CODPROD,
	    AI.DE_ITM PRODUCTO,
	    SI.QUANTITY_EXPECTED ESPERADA,
	    SI.QUANTITY_RECEIVED RECIBIDA,
	    SI.QUANTITY_DAMAGED DA�ADA
FROM RK_SHIPMENTS SHP
	INNER JOIN PA_SPR S ON S.ID_SPR = SHP.FROM_LOCATION_ID
	INNER JOIN RK_SHIPMENT_ITEM SI ON SI.SHIPMENT_ID = SHP.SHIPMENT_ID
	INNER JOIN AS_ITM AI ON AI.ID_ITM = SI.ITEM_ID
	INNER JOIN (
			SELECT PSR.ID_STR_RT,
				    PO.NM_ORGN
			FROM PA_ORGN PO
				INNER JOIN PA_STR_RTL PSR ON PSR.ID_PRTY = PO.ID_PRTY_ORGN
				AND PSR.RK_STORE_TYPE = 'C'
		) ST ON ST.ID_STR_RT = SHP.STORE_ID
WHERE SHP.CREATE_DATE >= '01/07/2016'
ORDER BY
	ST.NM_ORGN,
	SHP.CREATE_DATE,
	SHP.INVOICE_ID,
	AI.DE_ITM;