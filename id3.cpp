#include <iostream>
#include <vector>
#include <string>
#include <cmath>
#include <map>
#include <algorithm>
 
// Features: {age, income_in_thousands}
// Play Tennis, encoded:
// Outlook: Sunny=0, Overcast=1, Rain=2 | Temperature: Hot=0, Mild=1, Cool=2
// Humidity: High=0, Normal=1 | Wind: Weak=0, Strong=1 | Play: No=0, Yes=1
std::vector<std::vector<float>> X = {
    {0,0,0,0}, {0,0,0,1}, {1,0,0,0}, {2,1,0,0}, {2,2,1,0},
    {2,2,1,1}, {1,2,1,1}, {0,1,0,0}, {0,2,1,0}, {2,1,1,0},
    {0,1,1,1}, {1,1,0,1}, {1,0,1,0}, {2,1,0,1}
};

std::vector<int> y = {0,0,1,1,1,0,1,0,1,1,1,1,1,0};
struct Node {
    int feature_index;
    float threshold;
    int left_child_index;
    int right_child_index;
    int leaf_value;
    bool is_leaf;
};


std::vector<Node> tree;

float entropy(std::vector<int> labels){
    std::map<int, int> counts;
    for (int label : labels){
        counts[label]++;
    }
    float total = labels.size();
    float result = 0.0;
    for (std::map<int, int>::iterator it = counts.begin(); it != counts.end(); it++) {
        int label = it->first;
        int count = it->second;
        
        float p = count / total;
        
        if (p > 0) {
            result = result - (p * log2(p));
        }
    }
    
    return result;
}

//information_gain = entropy(before split) − weighted_average(entropy(after split))
float information_gain(std::vector<std::vector<float>> X, std::vector<int> y, int feature_index, float threshold){
    std::vector<int> left_labels;
    std::vector<int> right_labels;
    for(int i = 0; i < X.size(); i++){
        if(X[i][feature_index] < threshold){
            left_labels.push_back(y[i]);
        }
        else{
            right_labels.push_back(y[i]);
        }
    }
      float ent_before = entropy(y);
    
    float n_left = left_labels.size();
    float n_right = right_labels.size();
    float n_total = y.size();
    
    float weighted_entropy_avg = (n_left / n_total) * entropy(left_labels) + (n_right / n_total) * entropy(right_labels);
    
    float inf_gain = ent_before - weighted_entropy_avg;
    return inf_gain;

}

int majority_class(std::vector<int> y){
    std::map<int, int> counts;
    for (int label : y) {
        counts[label]++;
    }

    int best_label = -1;
    int best_count = -1;

    for (const auto& [label, count] : counts) {
        if (count > best_count) {
            best_count = count;
            best_label = label;
        }
    }

    return best_label;
}

Node build_tree(std::vector<std::vector<float>> X, std::vector<int> y, int max_depth = 2, int current_depth = 0, int min_samples_split = 5, float purity_threshold = 0.5){
    Node leaf_node;
    
    if(current_depth >= max_depth){
        leaf_node.is_leaf = true;
        leaf_node.leaf_value = majority_class(y);
        return leaf_node;
    }

    if((int)y.size() < min_samples_split){
        leaf_node.is_leaf = true;
        leaf_node.leaf_value = majority_class(y);
        return leaf_node;
    }

    if(entropy(y) <= purity_threshold){
        leaf_node.is_leaf = true;
        leaf_node.leaf_value = majority_class(y);
        return leaf_node;
    }

    float best_gain = -1;
    int best_feature = -1;
    float best_threshold = -1;

    for (int f = 0; f < X[0].size(); f++) {
        for (int i = 0; i < X.size(); i++) {
            float candidate_threshold = X[i][f];
            float gain = information_gain(X, y, f, candidate_threshold);
            if (gain > best_gain) {
                best_gain = gain;
                best_feature = f;
                best_threshold = candidate_threshold;
            }
        }
    }

    if (best_gain <= 0) {
        leaf_node.is_leaf = true;
        leaf_node.leaf_value = majority_class(y);
        return leaf_node;
    }

    std::vector<std::vector<float>> left_X, right_X;
    std::vector<int> left_y, right_y;
    for (int i = 0; i < X.size(); i++) {
        if (X[i][best_feature] < best_threshold) {
            left_X.push_back(X[i]);
            left_y.push_back(y[i]);
        } else {
            right_X.push_back(X[i]);
            right_y.push_back(y[i]);
        }
    }

    leaf_node.is_leaf = false;
    leaf_node.feature_index = best_feature;
    leaf_node.threshold = best_threshold; 

    if (left_y.empty()) {
        Node left_leaf;
        left_leaf.is_leaf = true;
        left_leaf.leaf_value = majority_class(y);
        tree.push_back(left_leaf);
        leaf_node.left_child_index = tree.size() - 1;
    } else {
        Node left_node = build_tree(left_X, left_y, max_depth, current_depth + 1, min_samples_split, purity_threshold);
        tree.push_back(left_node);
        leaf_node.left_child_index = tree.size() - 1;
    }

    if (right_y.empty()) {
        Node right_leaf;
        right_leaf.is_leaf = true;
        right_leaf.leaf_value = majority_class(y);
        tree.push_back(right_leaf);
        leaf_node.right_child_index = tree.size() - 1;
    } else {                        
        Node right_node = build_tree(right_X, right_y, max_depth, current_depth + 1, min_samples_split, purity_threshold);
        tree.push_back(right_node);
        leaf_node.right_child_index = tree.size() - 1;
    }

    return leaf_node;
}   

std::vector<std::string> feature_names = {"Outlook", "Temperature", "Humidity", "Wind"};

int predict(const Node& node, const std::vector<float>& row){
    if (node.is_leaf) return node.leaf_value;
    if (row[node.feature_index] < node.threshold) return predict(tree[node.left_child_index], row);
    else return predict(tree[node.right_child_index], row);
}


void print_tree(const Node& node, int depth){
    std::string indent(depth * 2, ' ');
    if (node.is_leaf) {
        std::cout << indent << "-> Leaf: predict " << (node.leaf_value == 1 ? "Yes" : "No") << "\n";
    } else {
        std::cout << indent << "[" << feature_names[node.feature_index] << " < " << node.threshold << "?]\n";
        std::cout << indent << " True:\n";
        print_tree(tree[node.left_child_index], depth + 1);
        std::cout << indent << " False:\n";
        print_tree(tree[node.right_child_index], depth + 1);
    }
}

int main(){
    std::vector<std::vector<float>> X_full = {
        {0,0,0,0}, {0,0,0,1}, {1,0,0,0}, {2,1,0,0}, {2,2,1,0},
        {2,2,1,1}, {1,2,1,1}, {0,1,0,0}, {0,2,1,0}, {2,1,1,0},
        {0,1,1,1}, {1,1,0,1}, {1,0,1,0}, {2,1,0,1}
    };
    std::vector<int> y_full = {0,0,1,1,1,0,1,0,1,1,1,1,1,0};

    std::cout << "entropy of full dataset: " << entropy(y_full) << "\n";
    std::cout << "gain from splitting on Humidity < 1: " << information_gain(X_full, y_full, 2, 1.0f) << "\n\n";

    std::vector<int> holdout_indices = {3, 7, 10};
    std::vector<std::vector<float>> X_train, X_test;
    std::vector<int> y_train, y_test;
    for (int i = 0; i < (int)X_full.size(); i++) {
        if (std::find(holdout_indices.begin(), holdout_indices.end(), i) != holdout_indices.end()) {
            X_test.push_back(X_full[i]);
            y_test.push_back(y_full[i]);
        } else {
            X_train.push_back(X_full[i]);
            y_train.push_back(y_full[i]);
        }
    }

    tree.clear();
    Node root = build_tree(X_train, y_train, 2, 0, 5, 0.5f);
    print_tree(root, 0);

    int correct = 0;
    for (int i = 0; i < (int)X_test.size(); i++) {
        int predicted = predict(root, X_test[i]);
        bool match = (predicted == y_test[i]);
        correct += match;
        std::cout << "row " << holdout_indices[i] << ": predicted "
                   << (predicted == 1 ? "Yes" : "No") << ", actual "
                   << (y_test[i] == 1 ? "Yes" : "No")
                   << (match ? "" : " -- wrong") << "\n";
    }
    std::cout << correct << "/" << X_test.size() << " correct on holdout\n";

    return 0;
}