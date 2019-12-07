; #FUNCTION# ====================================================================================================================
; Name ..........: Chatbot Text read (#-23)
; Description ...: This file is all related to READ CHAT IA (Fast) | Samkie based
; Syntax ........:
; Parameters ....: ReadChat()
; Return values .: IF THE STATE = -1 CHAT TEXT IS RETURNED IN TEXT, ANOTHER BOOLEAN OF RETURN.
; Author ........: Boludoz/Boldina
; Modified ......: Boludoz (5/7/2018|17/7/2018|5/3/2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: ReadChat()
; ===============================================================================================================================
#cs
Func ChatScroll()
	Setlog("ChatActions: Scroll", $COLOR_INFO)

	Local $iIntPreventTime = 0
	Local $iLastIntPrevent = 0

	For $i = 0 To 50 
		Local $hTimer = __TimerInit()
		While Random(15000, 25555, 1) > __TimerDiff($hTimer)
			Local $aCapture = MultiPSimple(303, 637, 311, 679, Hex(0x91D125, 6), 15)
			Local $aCapture = IsArray($aCapture) ? ($aCapture) : (MultiPSimple(295, 625, 310, 658, Hex(0xFFBC35, 6), 15))

			If IsArray($aCapture) And UBound($aCapture) > 1 Then 
				$aCapture[0] -= Random(5, 10, 1) 
				$aCapture[1] += Random(7, 10, 1)
				ClickP($aCapture)
			Else
				ExitLoop
			EndIf
		WEnd
		
		CheckScrollG($iIntPreventTime, $iLastIntPrevent)
		
		While Random(15000, 25555, 1) > __TimerDiff($hTimer)
			If CheckScrollW() and CheckScrollB() Then
				ClickDrag(185 + Random(1, 10, 1), 570 + Random(1, 10, 1) + $g_iMidOffsetY, 185 + Random(1, 10, 1) + $g_iMidOffsetY, 220 + Random(1, 10, 1))
				$iIntPreventTime = 0
				ElseIf not CheckScrollW() and not CheckScrollB() Then
				ClickDrag(185 + Random(1, 10, 1), 570 + Random(1, 10, 1) + $g_iMidOffsetY, 185 + Random(1, 10, 1) + $g_iMidOffsetY, 220 + Random(1, 10, 1))
				$iIntPreventTime += 1
				If CheckScrollG($iIntPreventTime, $iLastIntPrevent) Then ExitLoop 2
				ElseIf not CheckScrollB() and CheckScrollW() Then
				$iIntPreventTime = 0
				ExitLoop 2
			EndIf
		WEnd
	Next
EndFunc

Func CheckScrollG(ByRef $iIntPreventTime, ByRef $iLastIntPrevent)
	Local $aCapture = MultiPSimple(36, 554, 70, 672, Hex(0x979797, 6), 10)
	Local $iSuperAI = Abs(Int($iLastIntPrevent) - Int($aCapture[1]))
	If _Sleep(1500) Then Return
	If IsArray($aCapture) and UBound($aCapture) > 1 Then 
		If $iIntPreventTime < 2 and $iSuperAI = 0 Then Return True
		$iLastIntPrevent = $aCapture[1]
	EndIf
Return False
EndFunc

Func CheckScrollB()
	If MultiPSimple(230, 663, 310, 677, Hex(0x2B2B29, 6), 10) = 0 then 
		Return False
	Else
		Return True
	EndIf
EndFunc

Func CheckScrollW()
	If MultiPSimple(234, 662, 307, 677, Hex(0x8F8F87, 6), 25) = 0 then
		Return False
	Else
		Return True
	EndIf
EndFunc
#ce

Func ChatScroll()
	Local $aCapture = MultiPSimple(19, 673, 30, 678, Hex(0x70AC2A, 6), 15) ; Incomplete 
	If IsArray($aCapture) And UBound($aCapture) > 1 Then 
		$aCapture[0] = Random(15, 40, 1)
		$aCapture[1] = Int($aCapture[1])
		PureClickP($aCapture)
		Return
	EndIf
	
	Local $aCapture = MultiPSimple(17, 633, 35, 653, Hex(0xDCF984, 6), 15) ; Full
	If IsArray($aCapture) And UBound($aCapture) > 1 Then 
		$aCapture[0] = Random(15, 40, 1)
		$aCapture[1] += Random(1, 10, 1)
		PureClickP($aCapture)
		Return
	EndIf
	
	Return False
EndFunc

Func ReadChatIA(ByRef $sOCRString, $sCondition = -1, $bFast = True)
	Local $bResult = True
	Local $asFCKeyword = ""

		$bResult = False
		Local $aLastResult[1][2]
		Local $sDirectory = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\ChatActions\Chat"
		Local $returnProps = "objectpoints"
		Local $aCoor
		Local $aPropsValues
		Local $aCoorXY
		Local $result

		Local $iMax = 0
		Local $jMax = 0
		Local $i, $j, $k
				
		ChatScroll()
		
		ForceCaptureRegion()
		_CaptureRegion2(260,85,272,624)
		$g_hHBitmap2 = GetHHBitmapArea($g_hHBitmap2, 0, 0, 10, 539)
		$result = findMultiple($sDirectory, "FV", "FV", 0, 0, 0, $returnProps, False)

		Local $iCount = 0
			If Not IsArray($result) Then Return False
			; Multibot pay XML func is based on it !
			$iMax = UBound($result) - 1
			For $i = 0 To $iMax
				$aPropsValues = $result[$i] ; should be return objectname,objectpoints,objectlevel
				If UBound($aPropsValues) = 1 then
					$aCoor = StringSplit($aPropsValues[0], "|", $STR_NOCOUNT) ; objectpoints, split by "|" to get multi coor x,y ; same image maybe can detect at different location.
					If IsArray($aCoor) Then
						For $j = 0 To UBound($aCoor) - 1
							$aCoorXY = StringSplit($aCoor[$j], ",", $STR_NOCOUNT)
							ReDim $aLastResult[$iCount + 1][2]
							$aLastResult[$iCount][0] = Int($aCoorXY[0])
							$aLastResult[$iCount][1] = Int($aCoorXY[1]) + 82
							$iCount += 1
						Next
					EndIf
				EndIf
			Next
			If $iCount < 1 Then Return False
			_ArraySort($aLastResult, 1, 0, 0, 1) ; rearrange order by coor Y
			;_ArrayDisplay($aLastResult)
			$iMax = UBound($aLastResult) - 1

			Local $aIAVarTmp = $g_aIAVar
			_ArraySort($aIAVarTmp, 0, 0, 0, 1)
			_CaptureRegion2(0,0,287,732)
			For $i = 0 To $iMax
					If MultiPSimple(32, $aLastResult[$i][1], 135, $aLastResult[$i][1] + 33, Hex(0x92ED4D, 6), 20) <> 0 Then
						SetDebugLog("Chat IA : Own talk jumped.", $COLOR_INFO)
						ContinueLoop
					EndIf
						$sOCRString = ""
						For $ii = 0 To UBound($aIAVarTmp) - 1
						If _Sleep($DELAYDONATECC2) Then ExitLoop
							Switch $ii
								Case 0
									$sOCRString = getChatStringMod(30, $aLastResult[$i][1] + 43, "coc-latinA")
									SetDebugLog("getChatStringMod Latin : " & $sOCRString)
											If StringStripWS($sOCRString, $STR_STRIPALL) <> "" Then
											$g_aIAVar[0] += 1
											ExitLoop 1
										EndIf
								Case 1
									$sOCRString = getChatStringMod(30, $aLastResult[$i][1] + 43, "coc-latin-cyr")
									SetDebugLog("getChatStringMod Cyc : " & $sOCRString)
											If StringStripWS($sOCRString, $STR_STRIPALL) <> "" Then
											$g_aIAVar[1] += 1
											ExitLoop 1
										EndIf
								Case 2
									$sOCRString = getChatStringChineseMod(30, $aLastResult[$i][1] + 43)
									SetDebugLog("getChatStringChineseMod : " & $sOCRString)
											If StringStripWS($sOCRString, $STR_STRIPALL) <> "" Then
											$g_aIAVar[2] += 1
											ExitLoop 1
										EndIf
								Case 3
									$sOCRString = getChatStringKoreanMod(30, $aLastResult[$i][1] + 43)
									SetDebugLog("getChatStringKoreanMod : " & $sOCRString)
											If StringStripWS($sOCRString, $STR_STRIPALL) <> "" Then
											$g_aIAVar[3] += 1
											ExitLoop 1
										EndIf
								Case 4
									$sOCRString = getChatStringPersianMod(30, $aLastResult[$i][1] + 43)
									SetDebugLog("getChatStringPersianMod : " & $sOCRString)
											If StringStripWS($sOCRString, $STR_STRIPALL) <> "" Then
											$g_aIAVar[4] += 1
											ExitLoop 1
										EndIf
							EndSwitch
						Next
				If StringStripWS($sOCRString, $STR_STRIPALL) = "" Then 
					SetDebugLog("Chat IA : Unable to read Chat!", $COLOR_ERROR)
				Else
 					;SetLog("Chat : " & $sOCRString, $COLOR_INFO)
					;If $sCondition = -1 Then
					;	$bResult &= " " & $sOCRString
					;Else
 						Local $asFCKeyword = StringSplit($sCondition, "|", BitOR($STR_ENTIRESPLIT, $STR_NOCOUNT))

						For $j = 0 To UBound($asFCKeyword) - 1
							If StringInStr($sOCRString, $asFCKeyword[$j], 2) Then
								Setlog("Chat IA : " & $asFCKeyword[$j], $COLOR_SUCCESS)
								$bResult = True
								If $bFast = True Then Return $bResult
							EndIf
						Next
					;EndIf
				EndIf
			Next
	Return $bResult ; IF THE STATE = -1 CHAT TEXT IS RETURNED IN TEXT, ANOTHER BOOLEAN OF RETURN
EndFunc   ;==>ReadChatIA

Func getChatStringMod($x_start, $y_start, $language) ; -> Get string chat request - Latin Alphabetic - EN "DonateCC.au3"
	Local $sReturn = ""
		If getOcrAndCapture($language, $x_start, $y_start, 280, 16) <> "" Then
		$sReturn &= $g_sGetOcrMod
			For $i = 1 To 4
				If getOcrAndCapture($language, $x_start, $y_start + ($i*13), 280, 16) <> "" Then
					$sReturn &= " "
					$sReturn &= $g_sGetOcrMod
				Else
				ExitLoop
				EndIf
			Next
		EndIf
	Return $sReturn
EndFunc   ;==>getChatString

Func getChatStringChineseMod($x_start, $y_start) ; -> Get string chat request - Chinese - "DonateCC.au3"
	Local $sReturn = ""
	Local $bUseOcrImgLoc = True

		If getOcrAndCapture("chinese-bundle", $x_start, $y_start, 160, 14, Default, $bUseOcrImgLoc) <> "" Then
		$sReturn &= $g_sGetOcrMod
			For $i = 1 To 4
				If getOcrAndCapture("chinese-bundle", $x_start, $y_start + ($i*13), 160, 14, Default, $bUseOcrImgLoc) <> "" Then
					$sReturn &= " "
					$sReturn &= $g_sGetOcrMod
				Else
				ExitLoop
				EndIf
			Next
		EndIf
	Return $sReturn
EndFunc   ;==>getChatStringChinese

Func getChatStringKoreanMod($x_start, $y_start) ; -> Get string chat request - Korean - "DonateCC.au3"
	Local $sReturn = ""
	Local $bUseOcrImgLoc = True

		If getOcrAndCapture("korean-bundle", $x_start, $y_start, 160, 14, Default, $bUseOcrImgLoc) <> "" Then
		$sReturn &= $g_sGetOcrMod
			For $i = 1 To 4
				If getOcrAndCapture("korean-bundle", $x_start, $y_start + ($i*13), 160, 14, Default, $bUseOcrImgLoc) <> "" Then
					$sReturn &= " "
					$sReturn &= $g_sGetOcrMod
				Else
				ExitLoop
				EndIf
			Next
		EndIf
	Return $sReturn
EndFunc   ;==>getChatStringKorean

Func getChatStringPersianMod($x_start, $y_start) ; -> Get string chat request - Persian - "DonateCC.au3"
	Local $sReturn = ""
	Local $bUseOcrImgLoc = True

		If getOcrAndCapture("persian-bundle", $x_start, $y_start, 240, 20, Default, $bUseOcrImgLoc, True) <> "" Then
		$sReturn &= $g_sGetOcrMod
			For $i = 1 To 4
				If getOcrAndCapture("persian-bundle", $x_start, $y_start + ($i*13), 240, 20, Default, $bUseOcrImgLoc, True) <> "" Then
					$sReturn &= " "
					$sReturn &= $g_sGetOcrMod
				Else
				ExitLoop
				EndIf
			Next
		EndIf

		$sReturn = StringReverse($sReturn)
		$sReturn = StringReplace($sReturn, "A", "ا")
		$sReturn = StringReplace($sReturn, "B", "ب")
		$sReturn = StringReplace($sReturn, "C", "چ")
		$sReturn = StringReplace($sReturn, "D", "د")
		$sReturn = StringReplace($sReturn, "F", "ف")
		$sReturn = StringReplace($sReturn, "G", "گ")
		$sReturn = StringReplace($sReturn, "J", "ج")
		$sReturn = StringReplace($sReturn, "H", "ه")
		$sReturn = StringReplace($sReturn, "R", "ر")
		$sReturn = StringReplace($sReturn, "K", "ک")
		$sReturn = StringReplace($sReturn, "K", "ل")
		$sReturn = StringReplace($sReturn, "M", "م")
		$sReturn = StringReplace($sReturn, "N", "ن")
		$sReturn = StringReplace($sReturn, "P", "پ")
		$sReturn = StringReplace($sReturn, "S", "س")
		$sReturn = StringReplace($sReturn, "T", "ت")
		$sReturn = StringReplace($sReturn, "V", "و")
		$sReturn = StringReplace($sReturn, "Y", "ی")
		$sReturn = StringReplace($sReturn, "L", "ل")
		$sReturn = StringReplace($sReturn, "Z", "ز")
		$sReturn = StringReplace($sReturn, "X", "خ")
		$sReturn = StringReplace($sReturn, "Q", "ق")
		$sReturn = StringReplace($sReturn, ",", ",")
		$sReturn = StringReplace($sReturn, "0", " ")
		$sReturn = StringReplace($sReturn, "1", ".")
		$sReturn = StringReplace($sReturn, "22", "ع")
		$sReturn = StringReplace($sReturn, "44", "ش")
		$sReturn = StringReplace($sReturn, "55", "ح")
		$sReturn = StringReplace($sReturn, "66", "ض")
		$sReturn = StringReplace($sReturn, "77", "ط")
		$sReturn = StringReplace($sReturn, "88", "لا")
		$sReturn = StringReplace($sReturn, "99", "ث")
		$sReturn = StringStripWS($sReturn, 1 + 2)
		Return $sReturn
EndFunc   ;==>getChatStringPersian