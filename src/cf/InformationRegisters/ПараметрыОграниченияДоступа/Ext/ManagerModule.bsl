﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет данные регистра при полном обновлении вспомогательных данных.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьДанныеРегистра(ЕстьИзменения = Неопределено) Экспорт
	
	Если Не УправлениеДоступомСлужебный.ОграничиватьДоступНаУровнеЗаписейУниверсально() Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию1(Параметры) Экспорт
	
	// Регистрация данных не требуется.
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию1(Параметры) Экспорт
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
