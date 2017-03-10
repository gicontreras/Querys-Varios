SELECT FSB.ID_STR_RT PHARMACY_ID,
	    '21' COMPANY,
	    'J000263493' RIF,
	    FSB.NM_LOC PHARMACY_NAME,
	    FSB.DC_DY_BSN BUSINESS_DAY,
	    FSB.TYPE_DOC DOC_TYPE,
	    FSB.FISC_INI DOC_INI,
	    FSB.FISC_FIN DOC_FIN,
	    FSB.MO_TOT MO_TOTAL,
	    FSB.BASE_EXEN MO_EXE,
	    DECODE (FSB.VAT, 0, 0,
		12 --SIN CAMBIO DE ALICUOTA*/
		/* FSB.TAX --PARA CAMBIO DE ALICUOTA*/
		) TS_IMP_CONT,
	    NULL MO_VTA_NO_CONT,
	    NULL TS_IMP_NO_CONT,
	    DECODE (FSB.TYPE_DOC, 'FC', 'N', 'Y') IS_NC,
	    FSB.FISC_SERIAL,
	    FSB.FISC_INI CO_FISC_INI,
	    FSB.FISC_FIN CO_FISC_FIN,
	    FSB.ID_WS,
	    FSB.FISC_Z,
	    FSB.DC_DY_BSN FEC_ULT_FAC,
	    NULL MO_IMP_NO_CONT,
	    FSB.VAT MO_IMP_CONT,
	    NULL HOLDER_RIF,
	    NULL FISCAL_NAME,
	    FSB.BASE_VAT MO_VTA,
	    NULL MO_EXEN_NO_CONT
FROM (
		 SELECT TRN.ID_STR_RT,
			    PA.NM_LOC,
			    FAO.FISC_Z,
			    TRN.DC_DY_BSN,
			    TRN.ID_WS,
			    FAO.FISC_SERIAL,
          /*CASE WHEN SLS_TX.PE_TX IS NULL
          THEN
            0
          ELSE
            SLS_TX.PE_TX
          END
          TAX,--PARA CAMBIO DE ALICUOTA*/
          CASE WHEN SLS.MO_EXTN_LN_ITM_RTN < 0
          THEN
            'NC'
          ELSE
            'FC'
          END
          TYPE_DOC,
			    MIN (
          CASE WHEN RTL.MO_TND_TOT < 0
          THEN
            (
              SELECT MIN (A.FISC_TX_NUM)
              FROM FAO_TR_RTL A
                INNER JOIN TR_RTL B ON (A.ID_STR_RT = B.ID_STR_RT
                  AND A.ID_WS = B.ID_WS
                  AND A.DC_DY_BSN = B.DC_DY_BSN
                  AND A.AI_TRN = B.AI_TRN
                )
              WHERE A.ID_STR_RT = TRN.ID_STR_RT
              AND A.FISC_Z = FAO.FISC_Z
              AND A.DC_DY_BSN = TRN.DC_DY_BSN
              AND A.ID_WS = TRN.ID_WS
              AND A.FISC_SERIAL = FAO.FISC_SERIAL
              AND (A.AGREEMENT_ID IS NULL
                  OR A.AGREEMENT_ID NOT IN (98, 118, 127, 131)
                  )
              AND B.MO_TND_TOT < 0
            )
            ELSE
            (
              SELECT MIN (A.FISC_TX_NUM)
              FROM FAO_TR_RTL A
                INNER JOIN TR_RTL B ON (A.ID_STR_RT = B.ID_STR_RT
                  AND A.ID_WS = B.ID_WS
                  AND A.DC_DY_BSN = B.DC_DY_BSN
                  AND A.AI_TRN = B.AI_TRN
                )
              WHERE A.ID_STR_RT = TRN.ID_STR_RT
              AND A.FISC_Z = FAO.FISC_Z
              AND A.DC_DY_BSN = TRN.DC_DY_BSN
              AND A.ID_WS = TRN.ID_WS
              AND A.FISC_SERIAL = FAO.FISC_SERIAL
              AND (A.AGREEMENT_ID IS NULL
                  OR A.AGREEMENT_ID NOT IN (98, 118, 127, 131)
                  )
              AND B.MO_TND_TOT > 0
            )
          END
          ) FISC_INI,
			    MAX (
          CASE WHEN RTL.MO_TND_TOT < 0
          THEN
            (
              SELECT MAX (A.FISC_TX_NUM)
              FROM FAO_TR_RTL A
                INNER JOIN TR_RTL B ON (A.ID_STR_RT = B.ID_STR_RT
                  AND A.ID_WS = B.ID_WS
                  AND A.DC_DY_BSN = B.DC_DY_BSN
                  AND A.AI_TRN = B.AI_TRN
                )
              WHERE A.ID_STR_RT = TRN.ID_STR_RT
              AND A.FISC_Z = FAO.FISC_Z
              AND A.DC_DY_BSN = TRN.DC_DY_BSN
              AND A.ID_WS = TRN.ID_WS
              AND A.FISC_SERIAL = FAO.FISC_SERIAL
              AND (A.AGREEMENT_ID IS NULL
                  OR A.AGREEMENT_ID NOT IN (98, 118, 127, 131)
                  )
              AND B.MO_TND_TOT < 0
            )
            ELSE
            (
              SELECT MAX (A.FISC_TX_NUM)
              FROM FAO_TR_RTL A
                INNER JOIN TR_RTL B ON (A.ID_STR_RT = B.ID_STR_RT
                  AND A.ID_WS = B.ID_WS
                  AND A.DC_DY_BSN = B.DC_DY_BSN
                  AND A.AI_TRN = B.AI_TRN
                )
              WHERE A.ID_STR_RT = TRN.ID_STR_RT
              AND A.FISC_Z = FAO.FISC_Z
              AND A.DC_DY_BSN = TRN.DC_DY_BSN
              AND A.ID_WS = TRN.ID_WS
              AND A.FISC_SERIAL = FAO.FISC_SERIAL
              AND (A.AGREEMENT_ID IS NULL
                  OR A.AGREEMENT_ID NOT IN (98, 118, 127, 131)
                  )
              AND B.MO_TND_TOT > 0
            )
          END
				  ) FISC_FIN,
			    SUM (SLS.MO_EXTN_LN_ITM_RTN + SLS.MO_VAT_LN_ITM_RTN) - SUM (SLS.MO_EXTN_LN_ITM_RTN - SLS.MO_EXTN_DSC_LN_ITM) MO_TOT,
				NVL(
				  SUM(CASE WHEN (SLS.FL_TX = 0 AND SLS.ID_GP_TX =990) OR (SLS.FL_TX = 0 AND SLS.ID_GP_TX =992) OR (SLS.FL_TX = 1 AND SLS.ID_GP_TX =990) THEN
				  (SLS.MO_EXTN_DSC_LN_ITM - (SLS.MO_EXTN_LN_ITM_RTN - SLS.MO_EXTN_DSC_LN_ITM))
				  END),
				  0) BASE_EXEN,
				NVL(
				  SUM(CASE WHEN (SLS.FL_TX = 1 AND SLS.ID_GP_TX =992) THEN
				  (SLS.MO_EXTN_DSC_LN_ITM - (SLS.MO_EXTN_LN_ITM_RTN - SLS.MO_EXTN_DSC_LN_ITM))
				  END),
				  0) BASE_VAT, 
			    SUM (SLS.MO_VAT_LN_ITM_RTN) VAT
		 FROM FAO_TR_RTL FAO
			INNER JOIN PA_STR_RTL PA ON ( FAO.ID_STR_RT = PA.ID_STR_RT
      )
			INNER JOIN TR_TRN TRN ON ( TRN.ID_STR_RT = FAO.ID_STR_RT
        AND	TRN.ID_WS = FAO.ID_WS
				AND	TRN.DC_DY_BSN = FAO.DC_DY_BSN
				AND	TRN.AI_TRN = FAO.AI_TRN
			)
			INNER JOIN TR_RTL RTL ON ( TRN.ID_STR_RT = RTL.ID_STR_RT
				AND	TRN.ID_WS = RTL.ID_WS
				AND	TRN.DC_DY_BSN = RTL.DC_DY_BSN
				AND	TRN.AI_TRN = RTL.AI_TRN
			)
			INNER JOIN TR_LTM_SLS_RTN SLS ON ( SLS.ID_STR_RT = FAO.ID_STR_RT
				AND SLS.ID_WS = FAO.ID_WS
				AND SLS.DC_DY_BSN = FAO.DC_DY_BSN
				AND SLS.AI_TRN = FAO.AI_TRN
			)
      LEFT JOIN TR_LTM_SLS_RTN_TX SLS_TX ON ( SLS_TX.ID_STR_RT = SLS.ID_STR_RT
        AND SLS_TX.ID_WS = SLS.ID_WS
        AND SLS_TX.DC_DY_BSN = SLS.DC_DY_BSN
        AND SLS_TX.AI_TRN = SLS.AI_TRN
        AND SLS_TX.AI_LN_ITM = SLS.AI_LN_ITM
      ) 
     WHERE 
        FAO.DC_DY_BSN >= '2016-07-01'		AND
        FAO.DC_DY_BSN <= '2016-12-28'
      AND TRN.SC_TRN = 2
      AND TRN.ID_STR_RT IN(01002,01003,01004,01005,01006,01007)
      AND SLS.ID_ITM NOT IN (500001, 500002, 500003, 500068)
      AND SLS.FL_VD_LN_ITM = 0
     GROUP BY
        TRN.ID_STR_RT,
        PA.NM_LOC,
        FAO.FISC_Z,
        TRN.DC_DY_BSN,
        TRN.ID_WS,
        FAO.FISC_SERIAL,
        /*CASE WHEN SLS_TX.PE_TX IS NULL
        THEN
          0
        ELSE
          SLS_TX.PE_TX
        END,
       --PARA CAMBIO DE ALICUOTA*/
        CASE WHEN SLS.MO_EXTN_LN_ITM_RTN < 0
        THEN
          'NC'
        ELSE
          'FC'
        END
     ) FSB
ORDER BY FSB.DC_DY_BSN,FSB.NM_LOC,FSB.FISC_Z;