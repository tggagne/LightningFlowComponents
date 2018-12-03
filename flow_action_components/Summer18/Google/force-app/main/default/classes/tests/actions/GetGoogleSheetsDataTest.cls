@isTest
public class GetGoogleSheetsDataTest {

    class GoogleDriveMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            //Pretend that file Id equals file name requested
            if (stubbedMethodName == 'FindFileIdByName') {
                return listOfArgs[0];
            }
            if (stubbedMethodName == 'GetSpreadsheetData') {
                String fileId = listOfArgs[0].toString();
                if (fileId == 'ByAddress') {
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    result.add(row);
                    row = new List<String>();
                    row.add('');
                    row.add('test');
                    result.add(row);
                    return result;
                } else if (fileId == 'ByRight') {
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    result.add(row);
                    row = new List<String>();
                    row.add('1');
                    row.add('test');
                    result.add(row);
                    return result;
                } else if (fileId == 'ByBelow') {
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    result.add(row);
                    row = new List<String>();
                    row.add('1');
                    result.add(row);
                    row = new List<String>();
                    row.add('test');
                    result.add(row);
                    return result;
                } else if (fileId == 'OutsideOfTheRange') {
                    List<List<String>> result = new List<List<String>>();
                    return result;
                }
                return null;
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void GetGoogleSheetsDataImpl_CanFindByAddress() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.aSpreadsheetName = 'ByAddress';
        request.RelativeDirection1 = 'Address';
        request.TargetLabel1 = 'B2';
        GetGoogleSheetsData.Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value1);
    }

    @isTest
    public static void GetGoogleSheetsDataImpl_CanFindByRight() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.aSpreadsheetName = 'ByRight';
        request.RelativeDirection2 = 'Right';
        request.TargetLabel2 = '1';
        GetGoogleSheetsData.Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value2);
    }

    @isTest
    public static void GetGoogleSheetsDataImpl_CanFindByBelow() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.aSpreadsheetName = 'ByBelow';
        request.RelativeDirection3 = 'Below';
        request.TargetLabel3 = '1';
        GetGoogleSheetsData.Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('test', response.Value3);
    }
    
    @isTest
    public static void GetGoogleSheetsDataImpl_OutsideOfTheRange_ReturnsEmptyString() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.aSpreadsheetName = 'OutsideOfTheRange';
        request.RelativeDirection4 = 'Address';
        request.TargetLabel4 = 'A100';
        GetGoogleSheetsData.Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(true, response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assert(String.isBlank(response.Value4));
    }    
    
    @isTest
    public static void GetGoogleSheetsDataImpl_InvalidAddress_ThrowsException() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.aSpreadsheetName = 'InvalidAddress';
        request.RelativeDirection5 = 'Address';
        request.TargetLabel5 = 'Invalid';
        GetGoogleSheetsData.Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
        System.debug('Error message: ' + response.ErrorMessage);
        System.assertEquals(false, response.IsSuccess);
        System.assertEquals('Address "Invalid" doesn\'t contain row part', response.ErrorMessage);
        System.assert(String.isBlank(response.Value5));
    }

    @isTest
    public static void GetGoogleSheetsData_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        GetGoogleSheetsData.Request request = new GetGoogleSheetsData.Request();
        request.aSpreadsheetName = 'test';
        List<GetGoogleSheetsData.Request> requests = new List<GetGoogleSheetsData.Request> { request };
        List<GetGoogleSheetsData.Response> responses = GetGoogleSheetsData.GetGoogleSheetsData(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}