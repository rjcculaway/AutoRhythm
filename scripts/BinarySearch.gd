func binary_search(arr: Array, key: float):
	if arr.size() <= 0:
		return -1
	var left = 0
	var right = arr.size()
	var mid = -1
	while left <= right:
		mid = left + right / 2
		if key > arr[mid]:
			left = mid
		else:
			right = mid
		return mid
		
	return mid
