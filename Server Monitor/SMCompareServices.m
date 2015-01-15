//
//  SMCompareServices.m
//  Server Monitor
//
//  Created by Cesar on 18/11/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMCompareServices.h"

@implementation SMCompareServices

/*
 atributosBase <- [dBase todasLasLlaves]
	atributosNuevo <- [dNuevo todasLasLlaves]
	porcentajeTotal <- 1
	Desde contador = 0 hasta [atributosBase contar] repetir
 Si [atributosNuevo contieneObjeto: [atributosBase objetoEnIndice: contador]] entonces
 Si servicio.tipoMonitoreo = "contenido" entonces
 contenidoNuevo <- [atributosNuevo obtenerObjeto: Llave]
 contenidoBase <- [atributosBase obtenerObjeto: Llave]
 porcentaje <- verificarContenido(contenidoBase, contenidoNuevo)
 porcentajeTotal <- porcentajeTotal + porcentaje
 atributosEncontrados <- atributosEncontrados + 1
 Sino
 atributosEncontrados <- atributosEncontrados + 1
 Fin si
	Fin desde
	porcentajeSimilitud <- atributosEncontrados/[atributosBase contar]
 */

+(int)verifyContent: (NSString *)base downloaded: (NSString *)new{
    return 1;
}

+ (float)compareStructureWebServices: (NSDictionary *)base downloaded: (NSDictionary *)newService type: (NSString *)type{
    NSArray *baseAtributes = [base allKeys];
    int totalPercent = 0;
    int foundAttributes = 0;
    for (int i=0; i<[baseAtributes count]; i++) {
        if ([newService objectForKey:baseAtributes[i]]!=nil) {
            if ([type isEqualToString: @"contenido"]) {
                NSString *baseContent = [base objectForKey:baseAtributes[i]];
                NSString *newContent = [newService objectForKey:baseAtributes[i]];
                int percent = [self verifyContent:baseContent downloaded:newContent];
                totalPercent = totalPercent + percent;
            }
            foundAttributes++;
        }
    }
    totalPercent = totalPercent/baseAtributes.count;
    int numerator = foundAttributes*totalPercent;
    int denominator = baseAtributes.count>[newService allKeys].count?baseAtributes.count:[newService allKeys].count;
    
    return numerator/denominator;
}


+(float)compareStructureFTP:(NSDictionary *)base downloaded: (NSDictionary *)newService{
    NSArray *baseAtributes = [base allKeys];
    float totalPercent = 0;
    float foundAttributes = 0;
    for (int i=0; i<[baseAtributes count]; i++) {
        if ([newService objectForKey:baseAtributes[i]]!=nil) {
            foundAttributes++;
            NSString *baseContent = [base objectForKey:baseAtributes[i]];
            NSString *newContent = [newService objectForKey:baseAtributes[i]];
            if ([baseContent isEqualToString:newContent]) {
                totalPercent++;
            }
        }
    }
    
    totalPercent = totalPercent/baseAtributes.count;
    float numerator = foundAttributes*totalPercent;
    float denominator = baseAtributes.count>[newService allKeys].count?baseAtributes.count:[newService allKeys].count;
    
    
    
    return numerator/denominator;
}

@end
