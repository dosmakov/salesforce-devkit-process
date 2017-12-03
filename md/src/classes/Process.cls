/**
* @author Denis Osmakov <denis@osmakov.me>
* @description This is virtual process that can be run synchronous and asynchronous. You can extend from
* the given class and implement a business logic that can be run in different context. It is recommended 
* to use Singleton software design pattern to avoid creation of multiple instances of the same process.
* For example:
*
* public without sharing class MyProcess1 extends Process  {
*  
*   private static final MyProcess1 INSTANCE = new MyProcess1();
*   private MyProcess1() {}
*   public static MyProcess1 getInstance() {
*     return INSTANCE;
*   }
*  
* }
* 
*/
public virtual without sharing class Process {    
    /**
    * @description Implementation of a business logic
    */
    public virtual void BusinessLogic() {} 

    /**
    * @description Implementation of validation rules for the execution of bussines logic
    */
    public virtual Boolean isRun() {
    	return true;
    }

     /**
    * @description Dedicated method for validation rules for the execution of bussines logic on aync contex.
    */
    public virtual Boolean isRunASync() {
    	return isRun();
    }

    /**
    * @description Current process name
    */
    private final String ProcessName = String.valueOf(this).split(':')[0];
    
    /**
    * @description Counter for number of the process executions
    */
    private Integer NumberOfExecution = 0;

    /**
    * @description Return current process name
    * @return Process name
    */
    public String getName() {
        return ProcessName;
    }

    /**
    * @description Return number of process executions
    * @return Number of execution
    */
    public Integer getNumberOfExecution() {
    	return NumberOfExecution;
    }

    /**
    * @description Execute bussines logic synchronous
    */
    public void Run() {
    	if (!isRun()) return;
    	System.debug('Running Process: ' + this.getName());
    	NumberOfExecution++;
    	BusinessLogic();

    }

    /**
    * @description Queue bussines logic for further asynchronous execution
    * If the record was updated with workflow field updates, fires before update triggers and 
	* after update triggers one more time (and only one more time), in addition to standard 
	* validations. Custom validation rules, duplicate rules, and escalation rules are not run again.
	*
	* If you need to run a job after some other processing is done first by another job, you can chain 
	* queueable jobs. To chain a job to another job, submit the second job from the execute() method of your 
	* queueable class. You can add only one job from an executing job, which means that only one child job can 
	* exist for each parent job.
	*
	* As result: System.LimitException: Too many queueable jobs added to the queue: 2
	* 
	* You have to enqueueJob in the end of the async transaction, e.g in the process builde to avoid the exception. 
	* 
	* @see InvocableMethod method RunAsyncProcesses().
	* @see Queueable Apex https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_queueing_jobs.htm
	* @see Triggers and Order of Execution https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_order_of_execution.htm
    *
    */
    public void RunAsync() {
        
        if (!isRunASync()) return;
        
        ProcessQueueable AsyncJob = ProcessQueueable.getInstance();
        AsyncJob.Queue.add(this);

    }

    /**
    * @description Execute queued bussines logic asynchronous
    */
    @InvocableMethod(label='Run Async Processes' description='Run Async Processes')
    public static void RunAsyncProcesses() {
        ProcessQueueable AsyncJob = ProcessQueueable.getInstance();
        
        if (AsyncJob.Queue.isEmpty()) return;
        
        Id JobID = System.enqueueJob(AsyncJob);
        System.debug('Queued JobID: ' + JobID);
    }

}