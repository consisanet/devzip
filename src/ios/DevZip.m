/********* DevZip.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "GzipInputStream.h"

@interface DevZip : CDVPlugin {
  // Member variables go here.
}

- (void)decompressToString:(CDVInvokedUrlCommand*)command;
@end

@implementation DevZip

- (void)decompressToString:(CDVInvokedUrlCommand*)command
{
    //converte de bytearray para NSData
    NSData* data = [NSData dataWithBytes:[[command.arguments objectAtIndex:0] bytes] length:[[command.arguments objectAtIndex:0] length]];
    
    //Monta o caminho para salvar o .gzip
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *zipPath = [documentsDirectory stringByAppendingPathComponent:@"file.gz"];

    //grava o arquivo em disco
    BOOL salvo = [data writeToFile:zipPath atomically:YES];
    
    if (salvo) {
        
        //lê o arquivo gzip salvo
        NSString *str;
        GzipInputStream *is = [[GzipInputStream alloc] initWithFileAtPath:zipPath];
        [is open];
        NSString *line;
        while ((line = [is readLine])) {
            // do something with line
            if (!str) {
                str = line;
            } else {
                str = [str stringByAppendingString:line];
            }
        }
        [is close];
        
        //remove o arquivo
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        [fileManager removeItemAtPath:zipPath error: &error];
        
        if (error) {
            NSLog(@"Erro ao remover o arquivo zip:");
            NSLog(@"%@",[error localizedDescription]);
            
            //Retorna erro
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:[[command.arguments objectAtIndex:0] callbackId]];
        } else {
            
            //retorna o json
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:str];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:[command callbackId]];
        }
    } else {
        NSLog(@"Erro ao salvar o arquivo zip");
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Erro ao salvar o arquivo zip"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:[[command.arguments objectAtIndex:0] callbackId]];
    }
}

@end