<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
final class EOwnerType extends Enum {
	/**
	 * @AttributeType char
	 */
	const User = U;
	/**
	 * @AttributeType char
	 */
	const Project = P;
	/**
	 * @AttributeType char
	 */
	const Resource = R;
	/**
	 * @AttributeType char
	 * Comments
	 */
	const Metadata = M;
	/**
	 * @AttributeType char
	 * Files and attachments
	 */
	const Attachment = F;
	/**
	 * @AttributeType char
	 */
	const Company = C;
	/**
	 * @AttributeType char
	 * Addresses/Profiles
	 */
	const Profile = A;
	/**
	 * @AttributeType char
	 */
	const Billing = B;
	/**
	 * @AttributeType char
	 */
	const Activity = D;
	/**
	 * @AttributeType char
	 */
	const Task = T;
	/**
	 * @AttributeType char
	 */
	const Work = W;
	/**
	 * @AttributeType char
	 */
	const Rate = E;
	/**
	 * @AttributeType char
	 */
	const Deliverable = V;
	/**
	 * @AttributeType char
	 */
	const Appointment = N;
	/**
	 * @AttributeType char
	 */
	const Authorization = Z;
	/**
	 * @AttributeType char
	 */
	const Payment = G;
	/**
	 * @AttributeType char
	 */
	const Quote = Q;
	/**
	 * @AttributeType char
	 */
	const Invoice = I;
    /**
     * @AttributeType char
     */
    const Property = AU;
    /**
     * @AttributeType char
     */
    const Setting = AV;
    /**
     * @AttributeType char
     */
    const Reservation = AW;
}
?>