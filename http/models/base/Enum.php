<?php
/**
 * @access public
 * @author Sharron Denice
 * @package models.base
 */
abstract class Enum {
	protected $value = null;

	/**
	 * @access public
	 * @param string value string $value Value for this display type
	 * @ParamType value string
	 * string $value Value for this display type
	 */
	public function __construct($value = null) {
		if (!empty($value))
		    $this->setValue($value);
	}

	/**
	 * If the enum is requested as a string then this function will be automatically
	 * called and the value of this enum will be returned as a string.
	 * @access public
	 */
	public function __toString() {
		return (string)$this->value;
	}

	/**
	 * With a magic getter you can get the value from this enum using
	 * any variable name as in:
	 * 
	 * <code>
	 * $myEnum = new MyEnum(MyEnum::start);
	 * echo $myEnum->v;
	 * </code>
	 * @access public
	 * @param string $property
	 * @return string
	 * @ParamType $property string
	 * @ReturnType string
	 */
	public function __get($property) {
		return $this->value;
	}

	/**
	 * With a magic setter you can set the enum value using any variable
	 * name as in:
	 * 
	 * <code>
	 * $myEnum = new MyEnum(MyEnum::Start);
	 * $myEnum->v = MyEnum::End;
	 * </code>
	 * 
	 * @throws Exception Throws exception if an invalid type is used
	 * @access public
	 * @param string $property
	 * @param string $value
	 * @return string
	 * @ParamType $property string
	 * @ParamType $value string
	 * @ReturnType string
	 */
	public function __set($property, $value) {
		$this->setValue($value);
	}

	/**
	 * Validates if the type given is part of this enum class
	 * @access public
	 * @param string checkValue
	 * @return boolean
	 * @ParamType checkValue string
	 * @ReturnType boolean
	 */
	public function isValidEnumValue($checkValue) {
		$reflector = new ReflectionClass(get_class($this));
		
		foreach ($reflector->getConstants() as $validValue)
		{
		    if ($validValue == $checkValue) return true;
		}
		
		return false;
	}

	/**
	 * Tries to set the value of this enum
	 * @throws Exception If value is not part of this enum
	 * @access public
	 * @param string value
	 * @ParamType value string
	 */
	public function setValue($value) {
		if ($this->isValidEnumValue($value))
		    $this->value = $value;
		else
		    throw new Exception("Invalid type specified!");
	}

	/**
	 * @access public
	 */
	public function getValue() {
		return $this->value;
	}
}
?>