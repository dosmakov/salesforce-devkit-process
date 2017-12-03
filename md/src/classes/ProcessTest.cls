@isTest
public class ProcessTest {
	
	@testSetup 
	static void testSetup() {
		Test.loadData(Account.sObjectType, 'TestAccounts');
	}

	static testMethod void TestGetName() {
		MyProcess1 MyProcess1 = new MyProcess1();
		System.assertEquals(
			'MyProcess1',
			MyProcess1.getName()
		);
	}

	static testMethod void TestNumberOfExecution() {
		MyProcess1 MyProcess1 = new MyProcess1();
		System.assertEquals(
			0,
			MyProcess1.getNumberOfExecution()
		);

	}

	static testMethod void TestRun() {
		MyProcess1 MyProcess1 = new MyProcess1();
		MyProcess1.Run();
		System.assertEquals(
			1,
			MyProcess1.getNumberOfExecution()
		);

	}

	static testMethod void TestRunAsync() {
		MyProcess1 MyProcess1 = new MyProcess1();
		
		MyProcess1.RunAsync();
		
		System.assertEquals(
			0,
			MyProcess1.getNumberOfExecution()
		);
		
		List<Account> AccountsBefore = [SELECT Id FROM Account];
		
		Test.startTest();
		Process.RunAsyncProcesses();
		Test.stopTest();

		List<Account> AccountsAfter = [SELECT Id FROM Account];

		System.assertEquals(
			AccountsBefore.size() + 1,
			AccountsAfter.size()
		);

	}

	static testMethod void TestRunAsync2() {
		MyProcess1 MyProcess1 = new MyProcess1();
		MyProcess2 MyProcess2 = new MyProcess2();
		
		List<Account> AccountsBefore = [SELECT Id FROM Account];
		
		// Clone
		MyProcess1.Run();
		
		System.assertEquals(
			1,
			MyProcess1.getNumberOfExecution()
		);

		// Delete
		MyProcess2.RunAsync();
		
		System.assertEquals(
			0,
			MyProcess2.getNumberOfExecution()
		);

		Test.startTest();
		Process.RunAsyncProcesses();
		Test.stopTest();

		List<Account> AccountsAfter = [SELECT Id FROM Account];

		System.assertEquals(
			AccountsBefore.size(),
			AccountsAfter.size()
		);

	}

	/**
	* @description Fake process that clones Account.
	*/
	public class MyProcess1 extends Process  {
    	public override void BusinessLogic() {
    		String query = 'SELECT '
            + String.join(
                new List<String>(
                    Schema.sObjectType.Account 
                        .getSobjectType()
                        .getDescribe()
                        .fields
                        .getMap()
                        .keySet()
                ),
            ',') 
            + ' FROM Account LIMIT 1';

            Account Account = (Account)Database.query(query)[0];
            insert Account.clone();
    	}
	}

	/**
	* @description Fake process that delete Account.
	*/
	public class MyProcess2 extends Process  {
    	public override void BusinessLogic() {
    		delete [SELECT Id FROM Account LIMIT 1];
    	}
	}

}