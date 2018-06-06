<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
final class ESharedStatus extends Enum {
	/**
	 * @AttributeType int
	 */
	const UserActive = 1;
	/**
	 * @AttributeType int
	 */
	const UserDisabled = 2;
	/**
	 * @AttributeType int
	 */
	const CompanyActive = 10;
	/**
	 * @AttributeType int
	 */
	const CompanyDisabled = 11;
	/**
	 * @AttributeType int
	 */
	const ProjectIdea = 20;
	/**
	 * @AttributeType int
	 */
	const ProjectRequested = 21;
	/**
	 * @AttributeType int
	 */
	const ProjectApproved = 22;
	/**
	 * @AttributeType int
	 */
	const ProjectPlanning = 23;
	/**
	 * @AttributeType int
	 */
	const ProjectCurrent = 24;
	/**
	 * @AttributeType int
	 */
	const ProjectOnHold = 25;
	/**
	 * @AttributeType int
	 */
	const ProjectDead = 26;
	/**
	 * @AttributeType int
	 */
	const ProjectComplete = 27;
	/**
	 * @AttributeType int
	 */
	const TaskNew = 30;
	/**
	 * @AttributeType int
	 */
	const TaskOpen = 31;
	/**
	 * @AttributeType int
	 */
	const TaskComplete = 32;
	/**
	 * @AttributeType int
	 */
	const WorkNew = 40;
	/**
	 * @AttributeType int
	 */
	const WorkInvestigating = 41;
	/**
	 * @AttributeType int
	 */
	const WorkConfirmed = 42;
	/**
	 * @AttributeType int
	 */
	const WorkInWork = 43;
	/**
	 * @AttributeType int
	 */
	const WorkTesting = 44;
	/**
	 * @AttributeType int
	 */
	const WorkPostponed = 45;
	/**
	 * @AttributeType int
	 */
	const WorkComplete = 46;
	/**
	 * @AttributeType int
	 */
	const WorkFixed = 47;
	/**
	 * @AttributeType int
	 */
	const WorkDuplicate = 48;
	/**
	 * @AttributeType int
	 */
	const WorkReWork = 49;
	/**
	 * @AttributeType int
	 */
	const WorkOBE = 50;
	/**
	 * @AttributeType int
	 */
	const WorkWillNotWork = 51;
	/**
	 * @AttributeType int
	 */
	const ActivityPlanned = 60;
	/**
	 * @AttributeType int
	 */
	const ActivityCompleted = 61;
	/**
	 * @AttributeType int
	 */
	const DeliverableActive = 70;
	/**
	 * @AttributeType int
	 */
	const DeliverableDisabled = 71;
	/**
	 * @AttributeType int
	 */
	const AuthorizationActive = 80;
	/**
	 * @AttributeType int
	 */
	const AuthorizationInActive = 81;
	/**
	 * @AttributeType int
	 */
	const AppointmentPending = 90;
	/**
	 * @AttributeType int
	 */
	const AppointmentConfirmed = 91;
	/**
	 * @AttributeType int
	 */
	const AppointmentCanceled = 92;
	/**
	 * @AttributeType int
	 */
	const AppointmentNoShow = 93;
	/**
	 * @AttributeType int
	 */
	const AppointmentDone = 94;
	/**
	 * @AttributeType int
	 */
	const AppointmentPaid = 95;
	/**
	 * @AttributeType int
	 */
	const AppointmentRunningLate = 96;
	/**
	 * @AttributeType int
	 */
	const InvoiceGenerated = 100;
	/**
	 * @AttributeType int
	 */
	const InvoiceIssued = 101;
	/**
	 * @AttributeType int
	 */
	const InvoicePaid = 102;
	/**
	 * @AttributeType int
	 */
	const QuoteGenerated = 110;
	/**
	 * @AttributeType int
	 */
	const QuoteAccepted = 111;
}
?>