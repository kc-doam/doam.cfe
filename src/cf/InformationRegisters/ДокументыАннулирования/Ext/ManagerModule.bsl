﻿
#Область ПрограммныйИнтерфейс

Процедура ЗаписатьСведенияОбАннулировании(Документ, ЭД, ДокументАннулирования, ФайлАннулирования = Неопределено) Экспорт
	
	Запись = РегистрыСведений.ДокументыАннулирования.СоздатьМенеджерЗаписи();
	
	Запись.Документ = Документ;
	Запись.ЭД = ЭД;
	Запись.СоглашениеОбАннулировании = ДокументАннулирования;
	Запись.ФайлСоглашенияОбАннулировании = ФайлАннулирования;
	
	УстановитьПривилегированныйРежим(Истина);
	Запись.Записать();
	
КонецПроцедуры


#КонецОбласти