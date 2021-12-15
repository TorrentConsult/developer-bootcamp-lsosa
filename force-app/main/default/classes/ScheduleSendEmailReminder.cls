

global class ScheduleSendEmailReminder implements Schedulable {
    global void execute(SchedulableContext ctx) {
        sendEmailReminders sendBatch = new sendEmailReminders();
        Id batchId = Database.executeBatch(sendBatch);
    }
}