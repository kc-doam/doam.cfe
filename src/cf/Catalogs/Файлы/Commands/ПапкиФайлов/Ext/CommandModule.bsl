﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	КлючеваяОперация = "ФайлыОткрытиеФормыХранилищеФайлов";
	УИДЗамера = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь, КлючеваяОперация);
	
	Форма = ПолучитьФорму("Справочник.Файлы.Форма.ХранилищеФайлов", , ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	Если Форма.Открыта() Тогда 
		Форма.Активизировать();
		Возврат;
	КонецЕсли;
	Форма.Открыть();
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);	
	
КонецПроцедуры
