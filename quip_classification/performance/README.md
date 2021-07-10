## Pre-processing

In file `u24_lymphocyte/patch_extraction/save_svs_to_tiles.py`

IO time 
```python
124:    t0 = time.perf_counter()
125:    fh.write(fname, patch_arr, shape, start, count)
126:    iotime = iotime + time.perf_counter() -t0
```

Total execution time
```python
151:    t0 = time.perf_counter()
152:    main()
153:    print('DONE in {} sec'.format(time.perf_counter() -t0 ))
```

## Classification

In file `u24_lymphocyte/prediction/lymphocyte/pred_by_external_model.py`

IO time
```python
111:    t0 = time.perf_counter()
112:    png = np.array(Image.open(full_fn).convert('RGB'))
113:    iotime = iotime + time.perf_counter() - t0
```

Batch creation time
```python
166:    t0 = time.perf_counter()
167:    todo_list, inputs, inds, coor, rind = load_data(todo_list, rind, input_type)
168:    iotime = iotime + time.perf_counter() - t0
```

Prediction time
```python
172:    t0 = time.perf_counter()
173:    output = pred_by_external_model(model, inputs)
174:    predtime = predtime + time.perf_counter() - t0
```


Total execution time
```python
217:    t0 = time.perf_counter()
218:    classes = ['Lymphocytes']
219:    classn = len(classes)
220:    sys.setrecursionlimit(10000)
221:
222:    split_validation(classn, input_type)
223:    print('DONE in {} sec'.format(time.perf_counter() -t0 ))
```
