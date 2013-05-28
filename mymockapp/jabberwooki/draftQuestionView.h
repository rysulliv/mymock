//
//  draftQuestionView.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 2/8/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface draftQuestionView : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    
    NSMutableArray *pickerAnswers;
    NSString *question_text;
    NSString *answer_text;
    NSMutableData *_data;
}


- (IBAction)actionAnswerNow:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *processingAction;

- (IBAction)selectedAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *answerOptions;
@property (strong, nonatomic) IBOutlet UITextView *questionText;
@property (strong, nonatomic) IBOutlet UIPickerView *answerPicker;
@property (strong, nonatomic) IBOutlet UIButton *answerButton;
- (IBAction)done:(id)sender;

@end
