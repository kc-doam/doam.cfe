﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ЦветаРезультатовПроверки() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ЦветТекстаКонтрагентаПрекратившегоДеятельность",
		ЦветаСтиля.ЦветТекстаКонтрагентаПрекратившегоДеятельность);
		
	Результат.Вставить("ЦветТекстаНекорректногоКонтрагента",
		ЦветаСтиля.ЦветТекстаНекорректногоКонтрагента);
		
	Результат.Вставить("ЦветТекстаКонтрагентаДействующего",
		ЦветаСтиля.ЦветТекстаКонтрагентаДействующего);
		
	Результат.Вставить("ЦветФонаДокументаСНекорректнымиКонтрагентамиВСпискеДокументов",
		ЦветаСтиля.ЦветФонаДокументаСНекорректнымиКонтрагентамиВСпискеДокументов);
		
	Результат.Вставить("ЦветФонаКорректногоКонтрагентаВДокументе",
		ЦветаСтиля.ЦветФонаКорректногоКонтрагентаВДокументе);
		
	Результат.Вставить("ЦветФонаНекорректногоКонтрагентаВДокументе",
		ЦветаСтиля.ЦветФонаНекорректногоКонтрагентаВДокументе);
		
	Результат.Вставить("ЦветФонаФормы", ЦветаСтиля.ЦветФонаФормы);
	
	РаботаСКонтрагентамиПереопределяемый.ПриОпределенииЦветовРезультатовПроверки(Результат);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
