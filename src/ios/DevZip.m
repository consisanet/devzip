/********* DevZip.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "ZipArchive/SSZipArchive.h"

@interface DevZip : CDVPlugin {
  // Member variables go here.
}

- (void)decompressToString:(CDVInvokedUrlCommand*)command;
@end

@implementation DevZip

- (void)decompressToString:(CDVInvokedUrlCommand*)command
{
    // CDVPluginResult* pluginResult = nil;
    char *zipFile[] = [command.arguments objectAtIndex:0];

    //converte de bytearray para NSData
    NSData *arquivo = [NSData dataWithBytes: zipFile length: [zipFile length]];    

    NSFileManager *filemgr;
    NSString *currentpath;

    filemgr = [[NSFileManager alloc] init];

    currentpath = [filemgr currentDirectoryPath];
    currentpath = [currentpath stringByAppendingString:@"/file.zip"]

    //grava o arquivo em disco
    BOOL salvo = [data writeToFile:currentpath atomically:YES]

    if (salvo) {
        //extrai para o arquivo file.json
        NSString *unzipPath;
        unzipPath = [filemgr currentDirectoryPath];
        unzipPath = [currentpath stringByAppendingString:@"/file.json"]
        
        // Unzip
        [SSZipArchive unzipFileAtPath:currentpath toDestination:unzipPath];

        NSDictionary *dict = [self JSONFromFile];s

        // NSArray *colours = [dict objectForKey:@"colors"];
    }    

    // if (echo != nil && [echo length] > 0) {
    //     pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    // } else {
    //     pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    // }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"file" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end
