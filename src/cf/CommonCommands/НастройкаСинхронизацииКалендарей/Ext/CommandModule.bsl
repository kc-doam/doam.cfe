﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемыДокументооборота.РабочийКалендарь.СинхронизацияКалендарей") Тогда
		ОткрытьФорму("ОбщаяФорма.НастройкаСинхронизацииКалендарей");
	КонецЕсли;
	
КонецПроцедуры
